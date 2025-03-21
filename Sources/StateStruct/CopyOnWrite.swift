
import os.lock

@dynamicMemberLookup
public final class _BackingStorage<Value>: @unchecked Sendable {
    
  public var value: Value
  
  public subscript <U>(dynamicMember keyPath: KeyPath<Value, U>) -> U {
    _read { yield value[keyPath: keyPath] }
  }
  
  public subscript <U>(dynamicMember keyPath: KeyPath<Value, U?>) -> U? {
    _read { yield value[keyPath: keyPath] }
  }
  
  public subscript <U>(dynamicMember keyPath: WritableKeyPath<Value, U>) -> U {
    _read { yield value[keyPath: keyPath] }
    _modify { yield &value[keyPath: keyPath] }
  }
  
  public subscript <U>(dynamicMember keyPath: WritableKeyPath<Value, U?>) -> U? {
    _read { yield value[keyPath: keyPath] }
    _modify { yield &value[keyPath: keyPath] }
  }
  
  public init(_ value: consuming Value) {
    self.value = value
  }
    
  public func copy(with newValue: consuming Value) -> _BackingStorage {
    .init(newValue)
  }
  
  public func copy() -> _BackingStorage {
    return .init(value)
  }
}

extension _BackingStorage: Equatable where Value: Equatable {
  public static func == (lhs: _BackingStorage<Value>, rhs: _BackingStorage<Value>) -> Bool {
    lhs === rhs || lhs.value == rhs.value
  }  
}

extension _BackingStorage: Hashable where Value: Hashable {
  public func hash(into hasher: inout Hasher) {
    value.hash(into: &hasher)
  }
}

#if DEBUG
private struct Before {
  
  var value: Int
  
}

private struct After {
  
  var value: Int {
    get {
      _cow_value.value
    }
    set {
      if !isKnownUniquelyReferenced(&_cow_value) {
        _cow_value = .init(_cow_value.value)
      } else {
        _cow_value.value = newValue
      }      
    }
    _modify {
      if !isKnownUniquelyReferenced(&_cow_value) {
        _cow_value = .init(_cow_value.value)
      }
      yield &_cow_value.value
    }
  }
  
  private var _cow_value: _BackingStorage<Int>
  
}

#endif
