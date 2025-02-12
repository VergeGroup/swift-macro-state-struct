import Foundation
import os.lock

extension Array {
  mutating func modify(_ modifier: (inout Element) -> Void) {
    for index in indices {
      modifier(&self[index])
    }
  }
}


public final class _TrackingContext: @unchecked Sendable {

  @inlinable
  public var path: PropertyPath? {
    get {
      pathBox.withLockUnchecked {
        $0[Unmanaged.passUnretained(Thread.current).toOpaque()]
      }
    }
    set {
      pathBox.withLockUnchecked {
        $0[Unmanaged.passUnretained(Thread.current).toOpaque()] = newValue
      }
    }
  }

  @usableFromInline
  let pathBox: OSAllocatedUnfairLock<[UnsafeMutableRawPointer: PropertyPath]> = .init(
    uncheckedState: [:]
  )

  public init() {
  }
}

public struct PropertyPath: Equatable {

  public struct Component: Equatable {

    public let value: String

    public init(_ value: String) {
      self.value = value
    }

  }

  public var components: [Component] = []

  public init() {

  }
  
  public static func root<T>(of type: T.Type) -> PropertyPath {
    let path = PropertyPath().pushed(.init(_typeName(type)))
    return path
  }

  public consuming func pushed(_ component: Component) -> PropertyPath {
    self.components.append(component)
    return self
  }

}

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

public struct TrackingResult: Equatable {

  public var graph: PropertyNode
  
  public init(graph: consuming PropertyNode) {
    self.graph = graph
  }

  public mutating func accessorRead(path: PropertyPath?) {
    guard let path = path else {
      return
    }
    graph.applyAsRead(path: path)
  }

  public mutating func accessorSet(path: PropertyPath?) {
    guard let path = path else {
      return
    }
    graph.applyAsWrite(path: path)
  }

  public mutating func accessorModify(path: PropertyPath?) {
    guard let path = path else {
      return
    }
    graph.applyAsWrite(path: path)
  }
}

private enum ThreadDictionaryKey {
  case tracking
  case currentKeyPathStack
}

extension NSMutableDictionary {

  fileprivate var tracking: TrackingResult? {
    get {
      self[ThreadDictionaryKey.tracking] as? TrackingResult
    }
    set {
      self[ThreadDictionaryKey.tracking] = newValue
    }
  }
}

public enum _Tracking {

  public static func _tracking_modifyStorage(_ modifier: (inout TrackingResult) -> Void) {
    guard Thread.current.threadDictionary.tracking != nil else {
      return
    }
    modifier(&Thread.current.threadDictionary.tracking!)
  }
}
