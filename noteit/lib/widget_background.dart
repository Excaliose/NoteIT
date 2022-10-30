import 'package:flutter/material.dart';

class WidgetBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new DecoratedBox(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/images/Paper.png"),
          ),
        ),
      ),
    );
  }
}
