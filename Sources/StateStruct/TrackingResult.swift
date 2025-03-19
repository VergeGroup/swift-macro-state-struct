import os.lock

public final class TrackingResultRef: Sendable {
  
  public let resultBox: OSAllocatedUnfairLock<TrackingResult>
  
  public var result: TrackingResult {
    resultBox.withLock {
      $0
    }
  }
    
  public init(result: TrackingResult) {
    self.resultBox = .init(initialState: result)
  }
  
  public func modify(_ closure: (inout TrackingResult) -> Void) {
    resultBox.withLockUnchecked(closure)
  }
  public func accessorRead(path: PropertyPath?) {
    resultBox.withLockUnchecked { result in
      result.accessorRead(path: path)
    }
  }
  
  public func accessorSet(path: PropertyPath?) {
    resultBox.withLockUnchecked { result in
      result.accessorSet(path: path)
    }
  }
  
  public func accessorModify(path: PropertyPath?) {
    resultBox.withLockUnchecked { result in
      result.accessorModify(path: path)
    }
  }
}

public struct TrackingResult: Equatable, Sendable {
  
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
