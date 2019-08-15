import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class FirstFlutterPage extends StatelessWidget {
  static const String routeName = "/FirstFlutterPage";

  Future pushToNative() async {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop()');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.yellow,
      body: new Center(
        child: new Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              new Text("FirstFlutterPage",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 45,
                  )),
              new RaisedButton(
                  child: new Text(
                    "跳转到原生",
                  ),
                  onPressed: () => {pushToNative()}),
            ],
          ),
        ),
      ),
    );
  }
}
