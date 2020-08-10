import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_cast/src/air_play/air_play_event.dart';
import 'package:flutter_video_cast/src/air_play/air_play_platform.dart';
import 'package:stream_transform/stream_transform.dart';

class MethodChannelAirPlay extends AirPlayPlatform {

  final Map<int, MethodChannel> _channels = {};
  final _eventStreamController = StreamController<AirPlayEvent>.broadcast();

  MethodChannel channel(int id) {
    return _channels[id];
  }

  @override
  Future<void> init(int id) {
    MethodChannel channel;
    if (!_channels.containsKey(id)) {
      channel = MethodChannel('flutter_video_cast/airPlay_$id');
      channel.setMethodCallHandler((call) => _handleMethodCall(call, id));
      _channels[id] = channel;
    }
    return channel.invokeMethod<void>('airPlay#wait');
  }

  Stream<AirPlayEvent> _events(int id) =>
      _eventStreamController.stream.where((event) => event.id == id);

  @override
  Stream<RoutesOpeningEvent> onRoutesOpening({@required int id}) {
    return _events(id).whereType<RoutesOpeningEvent>();
  }

  @override
  Stream<RoutesClosedEvent> onRoutesClosed({@required int id}) {
    return _events(id).whereType<RoutesClosedEvent>();
  }

  Future<dynamic> _handleMethodCall(MethodCall call, int id) async {
    switch (call.method) {
      case 'airPlay#onRoutesOpening':
        _eventStreamController.add(RoutesOpeningEvent(id));
        break;
      case 'airPlay#onRoutesClosed':
        _eventStreamController.add(RoutesClosedEvent(id));
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
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'AirPlayButton',
        onPlatformViewCreated: onPlatformViewCreated,
        creationParams: arguments,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    return SizedBox();
  }
}
