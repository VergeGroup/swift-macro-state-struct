
@DebugDescription
public struct PropertyPath: Equatable, CustomDebugStringConvertible {

  public struct Component: Equatable {

    public let value: String

    public init(_ value: String) {
      self.value = value
    }

  }

  public var components: [Component] = [] {
    didSet {
      #if DEBUG
      _joined = components.map { $0.value }.joined(separator: ".")
      #endif
    }
  }

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
  
  #if DEBUG
  private var _joined: String = ""
  #endif
  
  #if DEBUG
  public var debugDescription: String {
    "\(_joined) \(components.count)"
  }
  #else
  public var debugDescription: String {
    "Components : \(components.count)"
  }
  #endif

}
