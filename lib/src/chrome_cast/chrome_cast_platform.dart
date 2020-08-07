import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_cast/src/chrome_cast/chrome_cast_event.dart';
import 'package:flutter_video_cast/src/chrome_cast/method_channel_chrome_cast.dart';

abstract class ChromeCastPlatform {
  static ChromeCastPlatform _instance = MethodChannelChromeCast();
  static get instance => _instance;

  Future<void> init(int id) {
    throw UnimplementedError('init() has not been implemented.');
  }

  Stream<SessionStartedEvent> onSessionStarted({@required int id}) {
    throw UnimplementedError('onSessionStarted() has not been implemented.');
  }

  Stream<SessionEndedEvent> onSessionEnded({@required int id}) {
    throw UnimplementedError('onSessionEnded() has not been implemented.');
  }

  Stream<RequestDidCompleteEvent> onRequestCompleted({@required int id}) {
    throw UnimplementedError('onRequestCompleted() has not been implemented.');
  }

  Stream<RequestDidFailEvent> onRequestFailed({@required int id}) {
    throw UnimplementedError('onSessionEnded() has not been implemented.');
  }

  Future<void> loadMedia(String url, {@required int id, }) {
    throw UnimplementedError('loadMedia() has not been implemented.');
  }

  Future<void> play({@required int id}) {
    throw UnimplementedError('play() has not been implemented.');
  }

  Future<void> pause({@required int id}) {
    throw UnimplementedError('pause() has not been implemented.');
  }

  Future<void> seek(bool relative, double interval, {@required int id}) {
    throw UnimplementedError('pause() has not been implemented.');
  }

  Future<bool> isConnected({@required int id}) {
    throw UnimplementedError('seek() has not been implemented.');
  }

  Future<bool> isPlaying({@required int id}) {
    throw UnimplementedError('isPlaying() has not been implemented.');
  }

  Widget buildView(
      Map<String, dynamic> arguments,
      PlatformViewCreatedCallback onPlatformViewCreated
      ) {
    throw UnimplementedError('buildView() has not been implemented.');
  }
}
