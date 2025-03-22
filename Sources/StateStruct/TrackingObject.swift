import Foundation.NSThread

/// A type that represents an object that can be tracked for changes.
/// This protocol is automatically implemented by types marked with `@Tracking` macro.
public protocol TrackingObject {
  var _tracking_context: _TrackingContext { get set }
}

extension TrackingObject {
   
  public var trackingResult: TrackingResult? {
    _tracking_context.trackingResultRef?.result
  }
  
  public consuming func tracked(using graph: consuming PropertyNode? = nil) -> Self {
    startNewTracking(using: graph)
    return self
  }
  
  public mutating func startNewTracking(using graph: consuming PropertyNode? = nil) {
    
    let newResult = TrackingResult(graph: graph ?? .init(name: _typeName(type(of: self))))
    
    _tracking_context = .init(trackingResultRef: .init(result: newResult))
    _tracking_context.path = .root(of: Self.self)
  }
  
  public func endTracking() {
    _tracking_context.trackingResultRef = nil
  }
    
}
