class AirPlayEvent {
  final int id;

  AirPlayEvent(this.id);
}

class RoutesOpeningEvent extends AirPlayEvent {
  RoutesOpeningEvent(int id) : super(id);
}

class RoutesClosedEvent extends AirPlayEvent {
  RoutesClosedEvent(int id) : super(id);
}
