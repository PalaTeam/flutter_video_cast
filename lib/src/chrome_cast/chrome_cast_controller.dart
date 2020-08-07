part of flutter_video_cast;

final ChromeCastPlatform _chromeCastPlatform = ChromeCastPlatform.instance;

class ChromeCastController {
  final int id;

  ChromeCastController._({@required this.id});

  static Future<ChromeCastController> init(int id) async {
    assert(id != null);
    await _chromeCastPlatform.init(id);
    return ChromeCastController._(id: id);
  }

  Future<void> loadMedia(String url) {
    return _chromeCastPlatform.loadMedia(url, id: id);
  }

  Future<void> play() {
    return _chromeCastPlatform.play(id: id);
  }

  Future<void> pause() {
    return _chromeCastPlatform.pause(id: id);
  }

  Future<void> seek({bool relative = false, double interval = 10.0}) {
    return _chromeCastPlatform.seek(relative, interval, id: id);
  }

  Future<bool> isConnected() {
    return _chromeCastPlatform.isConnected(id: id);
  }

  Future<bool> isPlaying() {
    return _chromeCastPlatform.isPlaying(id: id);
  }
}
