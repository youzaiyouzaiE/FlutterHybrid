import 'package:flutter/material.dart';
import 'package:flutter_plugin_batterylevel/flutter_plugin_batterylevel.dart';
import 'dart:async';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
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

  static const EventChannel _eventChannelPlugin =
      EventChannel('EventChannelPlugin');
  String showMessage = "NO Charging";
  static const MethodChannel _methodChannelPlugin =
      const MethodChannel('MethodChannelPlugin');
  static const BasicMessageChannel<String> _basicMessageChannel =
      const BasicMessageChannel('BasicMessageChannelPlugin', StringCodec());
  bool _isMethodChannelPlugin = false;
  StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();

    _basicMessageChannel.setMessageHandler((message) async {
      setState(() {
        showMessage = "MessageChannel" + message;
      });
      _streamSubscription = _eventChannelPlugin
          .receiveBroadcastStream()
          .listen(_onEvent, onError: _onError);
    });

    Future<String> returnToRaw() async {
      return 'I am Flutter, received your message';
    }


    _methodChannelPlugin.setMethodCallHandler((call) async {
      if(call.method == "getFlutterVersion") {
        return returnToRaw();
      } else {
        return "error";
      }
    });



    Future<dynamic> _handler(MethodCall methodCall) {
      if ("a_method" == methodCall.method) {
        print(methodCall.method);
      }
      return Future.value(true);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: new Container(
          padding: new EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  RaisedButton(
                    child: Text('获取iOS系统版本:'),
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
                  Text(
                    showMessage,
                  ),
                  Text(
                    showMessage,
                  ),
                ],
              ),
              Row(
               children: <Widget>[
                 Text(
                   showMessage,
                 ),
               ],
              ),
            ],
          ),
        ),
      ),
    );
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
      showMessage = 'EventChannel:' + message;
    });
  }

  void _onError(error) {
    setState(() {
      showMessage = 'EventChannel:' + error;
    });
  }

  void _getSystemVerion() async {
    String systemVersion =
        await _methodChannelPlugin.invokeMethod('getSystemVerison', null);
    setState(() {
      _systemVersion = systemVersion;
    });
  }
}
