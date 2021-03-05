/// Generic Event coming from the native side.
///
/// All AirPlayEvents contain the `id` that originated the event.
class AirPlayEvent {
  /// The ID of the button this event is associated to.
  final int id;

  /// Build a AirPlay Event, that relates a id with a given value.
  ///
  /// The `id` is the id of the button that triggered the event.
  AirPlayEvent(this.id);
}

/// An event fired while the AirPlay popup is opening.
class RoutesOpeningEvent extends AirPlayEvent {
  /// Build a RoutesOpening Event triggered from the button represented by `id`.
  RoutesOpeningEvent(int id) : super(id);
}

/// An event fired when the AirPlay popup has closed.
class RoutesClosedEvent extends AirPlayEvent {
  /// Build a RoutesClosed Event triggered from the button represented by `id`.
  RoutesClosedEvent(int id) : super(id);
}
