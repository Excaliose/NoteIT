import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noteit/Auth.dart';
import 'package:noteit/Home.dart';
import 'package:noteit/User.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: SplashScreen(),
      ),
    );
  }
}
