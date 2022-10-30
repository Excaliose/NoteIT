import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/About.png"),
                  fit: BoxFit.cover),
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  child: Align(
                    alignment: Alignment(0.0, -1.5),
                    child: Image.asset(
                      'assets/images/Me.jpg',
                      height: 400,
                      width: 200,
                    ),
                  ),
                ),
                Container(
                  child: Align(
                    alignment: Alignment(0.0, 0.4),
                    child: Image.asset(
                      'assets/images/STIKI.png',
                      height: 400,
                      width: 200,
                    ),
                  ),
                ),
                Container(
                  child: Align(
                    alignment: Alignment(0.0, -0.27),
                    child: Text(
                      "181111001",
                      style: TextStyle(fontSize: 26, color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  child: Align(
                    alignment: Alignment(0.0, -0.2),
                    child: Text(
                      "Samuel Ardiyanto",
                      style: TextStyle(fontSize: 26, color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  child: Align(
                    alignment: Alignment(0.0, 0.55),
                    child: Text(
                      "STIKI MALANG",
                      style: TextStyle(fontSize: 26, color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  child: Align(
                    alignment: Alignment(0.0, 0.9),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Back"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
