import 'dart:async';

import 'package:flutter/services.dart';

class FlutterPluginBatterylevel {
  static const MethodChannel _channel =
      const MethodChannel('flutter_plugin_batterylevel');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> get getBatteryLevel async {
    String batteryLevel;
    try {
      final int result = await _channel.invokeMethod('getBatteryLevel',{'paramName':'paramVale'});
      batteryLevel = 'Battery level: $result%.';
    } catch(e) {
      batteryLevel = 'Failed to get battery level.';
    }
    return batteryLevel;
  }


  /**
   * （2）EventChannel：Native调用Flutter App
   */
  static const EventChannel _eventChannel = const EventChannel('flutter_plugin_charging');

  void listenNativeEvent() {
    _eventChannel.receiveBroadcastStream().listen(_onEvent, onError:_onError);
  }

  void _onEvent(Object event) {
    print("Battery status: ${event == 'charging' ? '' : 'dis'}charging.");
  }

  void _onError(Object error) {
    print('Battery status: unknown.');
  }

}
