class ChromeCastEvent {
  final int id;

  ChromeCastEvent(this.id);
}

class SessionStartedEvent extends ChromeCastEvent {
  SessionStartedEvent(int id) : super(id);
}

class SessionEndedEvent extends ChromeCastEvent {
  SessionEndedEvent(int id) : super(id);
}

class RequestDidCompleteEvent extends ChromeCastEvent {
  RequestDidCompleteEvent(int id) : super(id);
}

class RequestDidFailEvent extends ChromeCastEvent {
  final String error;

  RequestDidFailEvent(int id, this.error) : super(id);
}
