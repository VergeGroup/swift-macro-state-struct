import Foundation.NSThread

/// A type that represents an object that can be tracked for changes.
/// This protocol is automatically implemented by types marked with `@Tracking` macro.
public protocol TrackingObject {
  var _tracking_context: _TrackingContext { get }
}

extension TrackingObject {
  
  public func tracking(
    using graph: consuming PropertyNode? = nil,
    _ applier: () throws -> Void
  ) rethrows -> TrackingResult {
    let current = Thread.current.threadDictionary.tracking
    startTracking()
    defer {
      Thread.current.threadDictionary.tracking = current
      endTracking()
    }
    
    Thread.current.threadDictionary.tracking = TrackingResult(graph: graph ?? .init(name: _typeName(type(of: self))))
    try applier()
    let result = Thread.current.threadDictionary.tracking!
    return result    
  }
  
  private func startTracking() {
    _tracking_context.path = .root(of: Self.self)
  }
  
  private func endTracking() {
  }
  
}
