/**
 Copy-on-Write property wrapper.
 Stores the value in reference type storage.
 */
@propertyWrapper
@dynamicMemberLookup
public struct Referencing<Value> {
    
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.storage === rhs.storage
  }
  
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
    self.storage = .init(consume wrappedValue)
  }
  
  public init(storage: _BackingStorage<Value>) {
    self.storage = storage
  }
   
  private var storage: _BackingStorage<Value>
  
  public var wrappedValue: Value {
    get {
      return storage.value
    }
    set {     
      if isKnownUniquelyReferenced(&storage) {
        storage.value = newValue
      } else {
        storage = .init(newValue)
      }      
    }
    _modify {
      if isKnownUniquelyReferenced(&storage) {
        yield &storage.value
      } else {
        var current = storage.value
        yield &current
        storage = .init(current)
      }
    }
  }
  
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
    lhs.storage === rhs.storage || lhs.wrappedValue == rhs.wrappedValue
  }
}

extension Referencing: Sendable where Value: Sendable {
  
}
