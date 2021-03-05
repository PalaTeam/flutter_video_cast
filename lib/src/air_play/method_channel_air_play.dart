import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_cast/src/air_play/air_play_event.dart';
import 'package:flutter_video_cast/src/air_play/air_play_platform.dart';
import 'package:stream_transform/stream_transform.dart';

/// An implementation of [AirPlayPlatform] that uses [MethodChannel] to communicate with the native code.
class MethodChannelAirPlay extends AirPlayPlatform {
  // Keep a collection of id -> channel
  // Every method call passes the int id
  final Map<int, MethodChannel?> _channels = {};

  /// Accesses the MethodChannel associated to the passed id.
  MethodChannel? channel(int id) {
    return _channels[id];
  }

  // The controller we need to broadcast the different events coming
  // from handleMethodCall.
  //
  // It is a `broadcast` because multiple controllers will connect to
  // different stream views of this Controller.
  final _eventStreamController = StreamController<AirPlayEvent>.broadcast();

  // Returns a filtered view of the events in the _controller, by id.
  Stream<AirPlayEvent> _events(int id) => _eventStreamController.stream.where((event) => event.id == id);

  @override
  Future<void> init(int id) async {
    MethodChannel? channel;
    if (!_channels.containsKey(id)) {
      channel = MethodChannel('flutter_video_cast/airPlay_$id');
      channel.setMethodCallHandler((call) => _handleMethodCall(call, id));
      _channels[id] = channel;
    }
    await channel?.invokeMethod<void>('airPlay#wait');
  }

  @override
  Stream<RoutesOpeningEvent> onRoutesOpening({required int id}) {
    return _events(id).whereType<RoutesOpeningEvent>();
  }

  @override
  Stream<RoutesClosedEvent> onRoutesClosed({required int id}) {
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
  Widget buildView(Map<String, dynamic> arguments, PlatformViewCreatedCallback onPlatformViewCreated) {
    return UiKitView(
      viewType: 'AirPlayButton',
      onPlatformViewCreated: onPlatformViewCreated,
      creationParams: arguments,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
