/**
 Copy-on-Write property wrapper.
 Stores the value in reference type storage.
 */
@propertyWrapper
@dynamicMemberLookup
@Tracking
public struct Referencing<Value> {
       
  public subscript <U>(dynamicMember keyPath: KeyPath<Value, U>) -> U {
    _read { yield wrappedValue[keyPath: keyPath] }
  }
  
  public subscript <U>(dynamicMember keyPath: KeyPath<Value, U?>) -> U? {
    _read { yield wrappedValue[keyPath: keyPath] }
  }
  
  public subscript <U>(dynamicMember keyPath: WritableKeyPath<Value, U>) -> U {
    _read { yield wrappedValue[keyPath: keyPath] }
    _modify { yield &wrappedValue[keyPath: keyPath] }
  }
  
  public subscript <U>(dynamicMember keyPath: WritableKeyPath<Value, U?>) -> U? {
    _read { yield wrappedValue[keyPath: keyPath] }
    _modify { yield &wrappedValue[keyPath: keyPath] }
  }
    
  public init(wrappedValue: consuming Value) {
    self._backing_wrappedValue = .init(wrappedValue)
  }
  
  public init(storage: _BackingStorage<Value>) {
    self._backing_wrappedValue = storage
  }
     
  public var wrappedValue: Value 
  
  public var projectedValue: Self {
    get {
      self
    }
    mutating set {
      self = newValue
    }
  }
  
}

extension Referencing where Value : Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs._backing_wrappedValue === rhs._backing_wrappedValue
  }
}

extension Referencing: Sendable where Value: Sendable {
  
}
