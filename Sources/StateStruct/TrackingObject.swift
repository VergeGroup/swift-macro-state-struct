/// A type that represents an object that can be tracked for changes.
/// This protocol is automatically implemented by types marked with `@Tracking` macro.
public protocol TrackingObject {
  var _tracking_context: _TrackingContext { get }
}
