public struct PropertyNode: Equatable, CustomDebugStringConvertible {

  public struct Status: OptionSet, Sendable {
    public let rawValue: Int8

    public init(rawValue: Int8) {
      self.rawValue = rawValue
    }

    public static let read = Status(rawValue: 1 << 0)
    public static let write = Status(rawValue: 1 << 1)
  }

  /**
   A name of property
   */
  public let name: String
  
  public var status: Status {
    var result: Status = []
    if readCount > 0 {
      result.insert(.read)
    }
    if writeCount > 0 {
      result.insert(.write)
    }
    return result
  }
  
  /**
   The number of times the final destination was accessed.
   */
  public private(set) var readCount: UInt16 = 0
  
  /**
   The number of times the final destination was accessed.
   */
  public private(set) var writeCount: UInt16 = 0

  public init(name: String) {
    self.name = name
  }

  public var nodes: [PropertyNode] = []
  
  private mutating func mark(status: Status) {
    switch status {
    case .read:
      readCount &+= 1
    case .write:
      writeCount &+= 1
    default:
      break
    }
  }

  public mutating func applyAsRead(path: PropertyPath) {
    apply(components: path.components, status: .read)
  }

  public mutating func applyAsWrite(path: PropertyPath) {
    apply(components: path.components, status: .write)
  }

  private mutating func apply(
    components: some RandomAccessCollection<PropertyPath.Component>, status: Status
  ) {
    
    guard let component = components.first else {
      return
    }

    guard name == component.value else {
      return
    }

    let next = components.dropFirst()

    guard !next.isEmpty else {
      self.mark(status: status)
      return
    }

    let targetName = next.first!.value

    let foundIndex: Int? = nodes.withUnsafeMutableBufferPointer { bufferPointer in
      for index in bufferPointer.indices {
        if bufferPointer[index].name == targetName {
          bufferPointer[index].apply(components: next, status: status)
          return index
        }
      }
      return nil
    }

    if foundIndex == nil {
      var newNode = PropertyNode(name: targetName)

      newNode.apply(components: next, status: status)

      nodes.append(newNode)
    }

  }

  public var debugDescription: String {
    prettyPrint()
  }
}

// MARK: PrettyPrint

extension PropertyNode {
  
  @discardableResult
  public func prettyPrint() -> String {
    let output = prettyPrint(indent: 0)
    return output
  }
  
  private func prettyPrint(indent: Int = 0) -> String {
    
    let indentation = String(repeating: "  ", count: indent)
    
    var statusDescription: String {
      var result = ""
      if readCount > 0 {
        result += "-(\(readCount))"
      }
      if writeCount > 0 {
        result += "+(\(writeCount))"
      }
      return result
    }
     
    var output = "\(indentation)\(name)\(statusDescription)"
    
    if !nodes.isEmpty {
      output += " {\n"
      output += nodes.map { $0.prettyPrint(indent: indent + 1) }.joined(separator: "\n")
      output += "\n\(indentation)}"
    }
    
    return output
  }

}

// MARK: Checks if there are changes
extension PropertyNode {

  public static func hasChanges(
    writeGraph: consuming PropertyNode,
    readGraph: consuming PropertyNode
  ) -> Bool {

    writeGraph.shakeAsWrite()
    readGraph.shakeAsRead()
    
    func _hasChanges(writeGraph: borrowing PropertyNode, readGraph: borrowing PropertyNode) -> Bool {
          
      if writeGraph.name == readGraph.name {
        
        if readGraph.nodes.isEmpty {
          // This is the leaf node. It matches enough to indicate there is change.
          return true
        }
        
        if writeGraph.nodes.isEmpty {
          // A case where the modification happened beyond the scope of the read.
          return true
        }
        
        for readNode in readGraph.nodes {
                              
          if let writeNode = writeGraph.nodes.first(where: { $0.name == readNode.name }) {
            
            let result = _hasChanges(
              writeGraph: writeNode,
              readGraph: readNode
            )
            
            if result {
              return true
            }
            
          }
        }
        
        return false

      }

      return false
    }

    let result = _hasChanges(writeGraph: writeGraph, readGraph: readGraph)

    return result
  }

  public consuming func sorted() -> PropertyNode {

    self.sort()

    return self
  }

  private mutating func sort() {

    self.nodes.modify {
      $0.sort()
    }

    self.nodes.sort { $0.name < $1.name }

  }

  public func hasChanges(for reader: PropertyNode) -> Bool {
    if status.contains(.write) {
      return true
    }

    for node in nodes {
      if let readerNode = reader.nodes.first(where: { $0.name == node.name }) {
        if node.hasChanges(for: readerNode) {
          return true
        }
      }
    }

    return false
  }
}

extension PropertyNode {
  
  public var isEmpty: Bool {
    nodes.isEmpty
  }

  /**
   Shake all nodes with `.read` status.
   */
  public mutating func shakeAsWrite() {
    
    func modify(_ nodes: inout [PropertyNode]) {
      nodes.removeAll {
        $0.status == .read
      }
      nodes.modify { node in
        if node.status == .read {
          node.nodes.removeAll()
        }
        modify(&node.nodes)
      }
    }
    
    modify(&nodes)
  }

}

extension PropertyNode {
  
  public consuming func shakedAsRead() -> PropertyNode {
    self.shakeAsRead()
    return self
  }
  
  public mutating func shakeAsRead() {
    
    func modify(_ nodes: inout [PropertyNode]) {
      nodes.modify { node in
        if node.nodes.isEmpty {
          return
        }
        
        if node.readCount != node.totalReadCount() {
          node.nodes.removeAll()
        }
             
        modify(&node.nodes)
      }
    }
    
    modify(&nodes)
    
  }
  
  private func totalReadCount() -> UInt16 {
    nodes.reduce(into: UInt16(0), {
      $0 &+= $1.readCount
    })
  }
  
}
