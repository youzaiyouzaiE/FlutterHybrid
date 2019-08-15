import 'package:flutter/material.dart';


class SecondFlutterPage extends StatelessWidget {

  static const String routeName = "/SecondFlutterPage";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("SecondFlutterPage"),
      ),
      body: new Container(
          child: new Center(
            child: new Text("SecondFlutterPage"),
          )),
    );
  }
}