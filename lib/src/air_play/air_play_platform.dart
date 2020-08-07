import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_cast/src/air_play/air_play_event.dart';
import 'package:flutter_video_cast/src/air_play/method_channel_air_play.dart';

abstract class AirPlayPlatform {
  static AirPlayPlatform _instance = MethodChannelAirPlay();
  static get instance => _instance;

  Future<void> init(int id) {
    throw UnimplementedError('init() has not been implemented.');
  }

  Stream<RoutesOpeningEvent> onRoutesOpening({@required int id}) {
    throw UnimplementedError('onRoutesOpening() has not been implemented.');
  }

  Stream<RoutesClosedEvent> onRoutesClosed({@required int id}) {
    throw UnimplementedError('onRoutesClosed() has not been implemented.');
  }

  Widget buildView(
      Map<String, dynamic> arguments,
      PlatformViewCreatedCallback onPlatformViewCreated
      ) {
    throw UnimplementedError('buildView() has not been implemented.');
  }
}
