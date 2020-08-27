part of flutter_video_cast;

final AirPlayPlatform _airPlayPlatform = AirPlayPlatform.instance;

class AirPlayButton extends StatelessWidget {
  final double size;
  final Color color;
  final Color activeColor;
  final VoidCallback onRoutesOpening;
  final VoidCallback onRoutesClosed;

  AirPlayButton({
    Key key,
    this.size = 30.0,
    this.color = Colors.black,
    this.activeColor = Colors.white,
    this.onRoutesOpening,
    this.onRoutesClosed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = {
      'red': color.red,
      'green': color.green,
      'blue': color.blue,
      'alpha': color.alpha,
      'activeRed': activeColor.red,
      'activeGreen': activeColor.green,
      'activeBlue': activeColor.blue,
      'activeAlpha': activeColor.alpha,
    };
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return SizedBox(
        width: size,
        height: size,
        child: _airPlayPlatform.buildView(args, _onPlatformViewCreated),
      );
    }
    return SizedBox();
  }

  void _onPlatformViewCreated(int id) async {
    await _airPlayPlatform.init(id);
    if (onRoutesOpening != null) {
      _airPlayPlatform.onRoutesOpening(id: id).listen((_) => onRoutesOpening());
    }
    if (onRoutesClosed != null) {
      _airPlayPlatform
          .onRoutesClosed(id: id)
          .listen((event) => onRoutesClosed());
    }
  }
}
