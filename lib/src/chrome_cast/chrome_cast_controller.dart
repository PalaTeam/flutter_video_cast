part of flutter_video_cast;

final ChromeCastPlatform _chromeCastPlatform = ChromeCastPlatform.instance;

/// Controller for a single ChromeCastButton instance running on the host platform.
class ChromeCastController {
  /// The id for this controller
  final int id;

  ChromeCastController._({required this.id});

  /// Initialize control of a [ChromeCastButton] with [id].
  static Future<ChromeCastController> init(int id) async {
    await _chromeCastPlatform.init(id);
    return ChromeCastController._(id: id);
  }

  /// Add listener for receive callbacks.
  Future<void> addSessionListener() {
    return _chromeCastPlatform.addSessionListener(id: id);
  }

  /// Remove listener for receive callbacks.
  Future<void> removeSessionListener() {
    return _chromeCastPlatform.removeSessionListener(id: id);
  }

  /// Load a new media by providing an [url].
  Future<void> loadMedia(String url) {
    return _chromeCastPlatform.loadMedia(url, id: id);
  }

  /// Plays the video playback.
  Future<void> play() {
    return _chromeCastPlatform.play(id: id);
  }

  /// Pauses the video playback.
  Future<void> pause() {
    return _chromeCastPlatform.pause(id: id);
  }

  /// If [relative] is set to false sets the video position to an [interval] from the start.
  ///
  /// If [relative] is set to true sets the video position to an [interval] from the current position.
  Future<void> seek({bool relative = false, double interval = 10.0}) {
    return _chromeCastPlatform.seek(relative, interval, id: id);
  }

  /// Stop the current video.
  Future<void> stop() {
    return _chromeCastPlatform.stop(id: id);
  }

  /// Returns `true` when a cast session is connected, `false` otherwise.
  Future<bool?> isConnected() {
    return _chromeCastPlatform.isConnected(id: id);
  }

  /// Returns `true` when a cast session is playing, `false` otherwise.
  Future<bool?> isPlaying() {
    return _chromeCastPlatform.isPlaying(id: id);
  }

  /// Returns current position.
  Future<Duration?> position() {
    return _chromeCastPlatform.position(id: id);
  }

  /// Returns video duration.
  Future<Duration?> duration() {
    return _chromeCastPlatform.duration(id: id);
  }
}
