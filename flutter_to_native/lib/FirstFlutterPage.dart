import 'package:flutter/material.dart';


class FirstFlutterPage extends StatelessWidget {

  static const String routeName = "/FirstFlutterPage";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.yellow,
      body: new Container(
          child: new Center(
            child: new Text(
                "FirstFlutterPage",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 45,
                )
            ),
          )),
    );
  }
}