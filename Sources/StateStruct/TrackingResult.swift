
public final class TrackingResultRef {
  
  public var result: TrackingResult
  
  public init(result: TrackingResult) {
    self.result = result
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
