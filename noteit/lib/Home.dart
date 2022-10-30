import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noteit/Auth.dart';
import 'package:noteit/Wrapper.dart';
import 'package:noteit/about.dart';
import 'package:noteit/create_task_screen.dart';
import 'package:noteit/widget_background.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final Firestore firestore = Firestore.instance;
  final AuthService _auth = AuthService();
  static String us = 'who';
  static String hi = 'Hi User';
  void initState() {
    super.initState();
    calluser();
  }

  void calluser() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    String usr = firebaseUser.uid;
    String hiusr = firebaseUser.email;
    us = usr;
    hi = hiusr;
    print(us);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double widthScreen = mediaQueryData.size.width;
    double heightScreen = mediaQueryData.size.height;
    return Scaffold(
      key: scaffoldState,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            WidgetBackground(),
            _buildWidgetListTodo(widthScreen, heightScreen, context),
            Align(
              alignment: Alignment(0.9, 0.7),
              child: FloatingActionButton(
                  heroTag: "btn1",
                  child: Icon(Icons.refresh),
                  onPressed: () {
                    calluser();
                  },
                  tooltip: 'Refresh'),
            ),
            Align(
              alignment: Alignment(0.9, 0.95),
              child: FloatingActionButton(
                heroTag: "btn2",
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () async {
                  bool result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CreateTaskScreen(isEdit: false)));
                  if (result != null && result) {
                    scaffoldState.currentState.showSnackBar(SnackBar(
                      content: Text('Note has been added'),
                    ));
                    setState(() {});
                  }
                },
                tooltip: 'Add Note',
              ),
            )
          ],
        ),
      ),
    );
  }

  Scaffold _buildWidgetListTodo(
      double widthScreen, double heightScreen, BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/images/Drawer.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Align(
                alignment: Alignment(0.0, -0.55),
                child: Text(
                  '$hi',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("assets/images/DrawerHeader.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'About',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => About()),
                );
              },
            ),
            ListTile(
              title: Text(
                'Log Out',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
      )),
      body: Center(
        child: Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("assets/images/Paper.png"),
              fit: BoxFit.fill,
            ),
          ),
          width: widthScreen,
          height: heightScreen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                child: Text(
                  'Your Note',
                  // ignore: deprecated_member_use
                  style: Theme.of(context).textTheme.title,
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: firestore
                      .collection('tasks/$us/task')
                      .orderBy('date')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                      padding: EdgeInsets.all(8.0),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        DocumentSnapshot document =
                            snapshot.data.documents[index];
                        Map<String, dynamic> task = document.data;
                        String strDate = task['date'];
                        DateTime tempDate =
                            new DateFormat("yyyy-MM-dd hh:mm:ss")
                                .parse(strDate);
                        String dat =
                            DateFormat("d MMMM y hh:mm a").format(tempDate);
                        return Card(
                          child: ListTile(
                            title: Text(task['name']),
                            subtitle: Text(
                              dat,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              return showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(task['description']),
                                  );
                                },
                              );
                            },
                            isThreeLine: false,
                            trailing: PopupMenuButton(
                              itemBuilder: (BuildContext context) {
                                return List<PopupMenuEntry<String>>()
                                  ..add(PopupMenuItem<String>(
                                    value: 'edit',
                                    child: Text('Edit'),
                                  ))
                                  ..add(PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Text('Delete'),
                                  ));
                              },
                              onSelected: (String value) async {
                                if (value == 'edit') {
                                  bool result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return CreateTaskScreen(
                                        isEdit: true,
                                        documentId: document.documentID,
                                        name: task['name'],
                                        description: task['description'],
                                        date: task['date'],
                                      );
                                    }),
                                  );
                                  if (result != null && result) {
                                    scaffoldState.currentState
                                        .showSnackBar(SnackBar(
                                      content: Text('Task has been updated'),
                                    ));
                                    setState(() {});
                                  }
                                } else if (value == 'delete') {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Are You Sure'),
                                        content: Text(
                                            'Do you want to delete ${task['name']}?'),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('No'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text('Delete'),
                                            onPressed: () {
                                              document.reference.delete();
                                              Navigator.pop(context);
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: Icon(Icons.more_vert),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 4), onDoneLoading);
  }

  onDoneLoading() async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Wrapper(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new DecoratedBox(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/images/Splash.png"),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
