/// Generic Event coming from the native side.
///
/// All ChromeCastEvents contain the `id` that originated the event. This should
/// never be `null`.
class ChromeCastEvent {
  /// The ID of the button this event is associated to.
  final int id;

  /// Build a ChromeCast Event, that relates a id with a given value.
  ///
  /// The `id` is the id of the button that triggered the event.
  ChromeCastEvent(this.id);
}

/// An event fired when a session of a [id] started.
class SessionStartedEvent extends ChromeCastEvent {
  /// Build a SessionStarted Event triggered from the button represented by `id`.
  SessionStartedEvent(int id) : super(id);
}

/// An event fired when a session of a [id] ended.
class SessionEndedEvent extends ChromeCastEvent {
  /// Build a SessionEnded Event triggered from the button represented by `id`.
  SessionEndedEvent(int id) : super(id);
}

/// An event fired when a request of a [id] completed.
class RequestDidCompleteEvent extends ChromeCastEvent {
  /// Build a RequestDidComplete Event triggered from the button represented by `id`.
  RequestDidCompleteEvent(int id) : super(id);
}

/// An event fired when a request of a [id] failed.
class RequestDidFailEvent extends ChromeCastEvent {
  /// The error message.
  final String? error;

  /// Build a RequestDidFail Event triggered from the button represented by `id`.
  RequestDidFailEvent(int id, this.error) : super(id);
}
