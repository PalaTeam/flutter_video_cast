import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_cast/src/chrome_cast/chrome_cast_event.dart';
import 'package:flutter_video_cast/src/chrome_cast/chrome_cast_platform.dart';
import 'package:stream_transform/stream_transform.dart';

class MethodChannelChromeCast extends ChromeCastPlatform {
  final Map<int, MethodChannel> _channels = {};
  final _eventStreamController = StreamController<ChromeCastEvent>.broadcast();

  MethodChannel channel(int id) {
    return _channels[id];
  }

  @override
  Future<void> init(int id) {
    MethodChannel channel;
    if (!_channels.containsKey(id)) {
      channel = MethodChannel('plugins.flutter.io/multiPlayer/chromeCast_$id');
      channel.setMethodCallHandler((call) => _handleMethodCall(call, id));
      _channels[id] = channel;
    }
    return channel.invokeMethod<void>('chromeCast#wait');
  }

  Stream<ChromeCastEvent> _events(int id) =>
      _eventStreamController.stream.where((event) => event.id == id);

  @override
  Stream<SessionStartedEvent> onSessionStarted({int id}) {
    return _events(id).whereType<SessionStartedEvent>();
  }

  @override
  Stream<SessionEndedEvent> onSessionEnded({int id}) {
    return _events(id).whereType<SessionEndedEvent>();
  }

  @override
  Stream<RequestDidCompleteEvent> onRequestCompleted({int id}) {
    return _events(id).whereType<RequestDidCompleteEvent>();
  }

  @override
  Stream<RequestDidFailEvent> onRequestFailed({int id}) {
    return _events(id).whereType<RequestDidFailEvent>();
  }

  @override
  Future<void> loadMedia(String url, {@required int id}) {
    final Map<String, dynamic> args = { 'url' : url };
    return channel(id).invokeMethod<void>('chromeCast#loadMedia', args);
  }

  @override
  Future<void> play({@required int id}) {
    return channel(id).invokeMethod<void>('chromeCast#play');
  }

  @override
  Future<void> pause({@required int id}) {
    return channel(id).invokeMethod<void>('chromeCast#pause');
  }

  @override
  Future<void> seek(bool relative, double interval, {@required int id}) {
    final Map<String, dynamic> args = {
      'relative' : relative,
      'interval' : interval
    };
    return channel(id).invokeMethod<void>('chromeCast#seek', args);
  }

  @override
  Future<bool> isConnected({@required int id}) {
    return channel(id).invokeMethod<bool>('chromeCast#isConnected');
  }

  @override
  Future<bool> isPlaying({@required int id}) {
    return channel(id).invokeMethod<bool>('chromeCast#isPlaying');
  }

  Future<dynamic> _handleMethodCall(MethodCall call, int id) async {
    switch (call.method) {
      case 'chromeCast#didStartSession':
        _eventStreamController.add(SessionStartedEvent(id));
        break;
      case 'chromeCast#didEndSession':
        _eventStreamController.add(SessionEndedEvent(id));
        break;
      case 'chromeCast#requestDidComplete':
        _eventStreamController.add(RequestDidCompleteEvent(id));
        break;
      case 'chromeCast#requestDidFail':
        _eventStreamController.add(RequestDidFailEvent(
            id,
            call.arguments['error']
        ));
        break;
      default:
        throw MissingPluginException();
    }
  }

  @override
  Widget buildView(
      Map<String, dynamic> arguments,
      PlatformViewCreatedCallback onPlatformViewCreated
      ) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'ChromeCastButton',
        onPlatformViewCreated: onPlatformViewCreated,
        creationParams: arguments,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'ChromeCastButton',
        onPlatformViewCreated: onPlatformViewCreated,
        creationParams: arguments,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    return Text('$defaultTargetPlatform is not supported by ChromeCast plugin');
  }
}
