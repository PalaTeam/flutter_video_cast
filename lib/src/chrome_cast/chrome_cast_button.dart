part of flutter_video_cast;

class ChromeCastButton extends StatelessWidget {
  final double size;
  final Color color;
  final OnButtonCreated onButtonCreated;
  final VoidCallback onSessionStarted;
  final VoidCallback onSessionEnded;
  final VoidCallback onRequestCompleted;
  final OnRequestFailed onRequestFailed;

  ChromeCastButton(
      {Key key,
      this.size = 30.0,
      this.color = Colors.black,
      this.onButtonCreated,
      this.onSessionStarted,
      this.onSessionEnded,
      this.onRequestCompleted,
      this.onRequestFailed})
      : assert(
            defaultTargetPlatform == TargetPlatform.iOS ||
                defaultTargetPlatform == TargetPlatform.android,
            '$defaultTargetPlatform is not supported by this plugin'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = {
      'red': color.red,
      'green': color.green,
      'blue': color.blue,
      'alpha': color.alpha
    };
    return SizedBox(
      width: size,
      height: size,
      child: _chromeCastPlatform.buildView(args, _onPlatformViewCreated),
    );
  }

  Future<void> _onPlatformViewCreated(int id) async {
    final ChromeCastController controller = await ChromeCastController.init(id);
    if (onButtonCreated != null) {
      onButtonCreated(controller);
    }
    if (onSessionStarted != null) {
      _chromeCastPlatform
          .onSessionStarted(id: id)
          .listen((_) => onSessionStarted());
    }
    if (onSessionEnded != null) {
      _chromeCastPlatform
          .onSessionEnded(id: id)
          .listen((_) => onSessionEnded());
    }
    if (onRequestCompleted != null) {
      _chromeCastPlatform
          .onRequestCompleted(id: id)
          .listen((_) => onRequestCompleted());
    }
    if (onRequestFailed != null) {
      _chromeCastPlatform
          .onRequestFailed(id: id)
          .listen((event) => onRequestFailed(event.error));
    }
  }
}

typedef void OnButtonCreated(ChromeCastController controller);
typedef void OnRequestFailed(String error);
