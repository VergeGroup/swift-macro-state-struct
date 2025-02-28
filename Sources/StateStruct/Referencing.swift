
/**
 Copy-on-Write property wrapper.
 Stores the value in reference type storage.
 */
@propertyWrapper
@dynamicMemberLookup
public struct Referencing<State> {
  
  public struct TrackingInfo {
    public let context: _TrackingContext
  }
  
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.storage === rhs.storage
  }
  
  public subscript <U>(dynamicMember keyPath: KeyPath<State, U>) -> U {
    _read { yield wrappedValue[keyPath: keyPath] }
  }
  
  public subscript <U>(dynamicMember keyPath: KeyPath<State, U?>) -> U? {
    _read { yield wrappedValue[keyPath: keyPath] }
  }
  
  public subscript <U>(dynamicMember keyPath: WritableKeyPath<State, U>) -> U {
    _read { yield wrappedValue[keyPath: keyPath] }
    _modify { yield &wrappedValue[keyPath: keyPath] }
  }
  
  public subscript <U>(dynamicMember keyPath: WritableKeyPath<State, U?>) -> U? {
    _read { yield wrappedValue[keyPath: keyPath] }
    _modify { yield &wrappedValue[keyPath: keyPath] }
  }
  
  
  public init(wrappedValue: consuming State) {
    self.storage = Storage(consume wrappedValue)
  }
    
  public init(wrappedValue: consuming State, tracking: TrackingInfo) {
    self.storage = Storage(consume wrappedValue)
  }
  
  public var _storagePointer: OpaquePointer {
    return .init(Unmanaged.passUnretained(storage).toOpaque())
  }
  
  private var storage: Storage<State>
  private let trackingInfo: TrackingInfo?
  
  public var wrappedValue: State {
    _read {
      (storage.value as? TrackingObject)?._tracking_context.path = _tracking_context.path?.pushed(.init("count"))
      _Tracking._tracking_modifyStorage {
        $0.accessorRead(path: _tracking_context.path?.pushed(.init("count")))
      }
      yield storage.value
    }
    set {
      (storage.value as? TrackingObject)?._tracking_context.path = _tracking_context.path?.pushed(.init("count"))
      _Tracking._tracking_modifyStorage {
        $0.accessorSet(path: _tracking_context.path?.pushed(.init("count")))
      }
      if !isKnownUniquelyReferenced(&_backing_count) {
        storage = .init(newValue)
      } else {
        storage.value = newValue
      }
      
    }
    _modify {
      (storage.value as? TrackingObject)?._tracking_context.path = _tracking_context.path?.pushed(.init("count"))
      _Tracking._tracking_modifyStorage {
        $0.accessorModify(path: _tracking_context.path?.pushed(.init("count")))
      }
      if !isKnownUniquelyReferenced(&_backing_count) {
        storage = .init(_backing_count.value)
      }
      yield &storage.value
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

extension Referencing where State : Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.storage === rhs.storage || lhs.wrappedValue == rhs.wrappedValue
  }
}

final class Storage<Value>: @unchecked Sendable {
  
  var value: Value
  
  init(_ value: consuming Value) {
    self.value = value
  }
  
  func read<T>(_ thunk: (borrowing Value) -> T) -> T {
    thunk(value)
  }
  
}

extension Referencing: Sendable where State: Sendable {
  
}
