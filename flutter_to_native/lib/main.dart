import 'package:flutter/material.dart';
import 'package:flutter_plugin_batterylevel/flutter_plugin_batterylevel.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:io';
import 'FirstFlutterPage.dart';
import 'SecondFlutterPage.dart';
import 'dart:ui';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _widgetForRoute(window.defaultRouteName),
    );
  }
}

Widget _widgetForRoute(String route) {
  print('gao' + route);
  switch (route) {
    case "/FirstFlutterPage":
      return  new FirstFlutterPage();
    case "/":
      return new MyHomePage();
    default:
      return new MyHomePage();
  }
}



class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _systemVersion = 'NO SystemVersion';

  String _receiveMessage = "NO ReceiveMessage";

  String _sendMessage = "NO SendMessage";

  String _eventChannelMessage = "NO EventChannelMessage";


  static const BasicMessageChannel<String> _basicMessageChannel = const BasicMessageChannel('BasicMessageChannelPlugin', StringCodec());

  static const MethodChannel _methodChannelPlugin = const MethodChannel('MethodChannelPlugin');

  static const EventChannel _eventChannelPlugin = EventChannel('EventChannelPlugin');

  StreamSubscription _streamSubscription;

  Future<String> returnToRaw() async {
    return Platform.version;
  }

  Future<String> returnToRawe() async {
    return "gaogaogao";
  }

  @override
  void initState() {

    super.initState();

    _basicMessageChannel.setMessageHandler((message){

      setState(() {
        _receiveMessage =  message;
      });

    });

    _methodChannelPlugin.setMethodCallHandler((call) async {
      if(call.method == "getFlutterVersion") {
        return returnToRaw();
      } else {
        return "error";
      }
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: new Container(
          padding: new EdgeInsets.all(10.0),
          margin: new EdgeInsets.only(top: 500, left:10, bottom: 100, right: 10),
          color: Colors.yellowAccent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  RaisedButton(
                    child: Text('MC获取iOS系统版本:'),
                    onPressed: () {
                      _getSystemVerion();
                    },
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                  ),
                  Text(
                    _systemVersion,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  RaisedButton(
                    child: Text('MessageC发送消息:'),
                    onPressed: () {
                      _sendMessageByMessageChannel();
                    },
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                  ),
                ],
              ),
              TextField(
                onChanged:(message) {
                  _sendMessage = message;
                },
              ),
              Container(
                padding: EdgeInsets.all(10.0),
              ),
              Row(
                children: <Widget>[
                  RaisedButton(
                    child: Text("MessageC收到信息："),
                    onPressed: () {

                    },
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                  ),
                  Text(
                    _receiveMessage,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  RaisedButton(
                    child: Text("EventC收到信息："),
                    onPressed: () {
                      _streamSubscription = _eventChannelPlugin
                          .receiveBroadcastStream()
                          .listen(_onEvent, onError: _onError);
                    },
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                  ),
                  Text(
                    _eventChannelMessage,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendMessageByMessageChannel() async{
    String receiveMessage = await _basicMessageChannel.send(_sendMessage);
    setState(() {
      _receiveMessage = receiveMessage;
    });
  }

  void _getSystemVerion() async {
    String systemVersion =
    await _methodChannelPlugin.invokeMethod('getSystemVerison', null);
    setState(() {
      _systemVersion = systemVersion;
    });
  }

  @override
  void dispose() {
    if (_streamSubscription != null) {
      _streamSubscription.cancel();
      _streamSubscription = null;
    }
    super.dispose();
  }

  void _onEvent(message) {
    print(message);
    setState(() {
      _eventChannelMessage = message;
    });
  }

  void _onError(error) {
    setState(() {
      _eventChannelMessage = error;
    });
  }
}

