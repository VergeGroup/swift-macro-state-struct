
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
