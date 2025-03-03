import MacroTesting
import StateStructMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class COWTrackingProperyMacroTests: XCTestCase {

  override func invokeTest() {
    withMacroTesting(
      record: false,
      macros: [
        "COWTrackingProperty": COWTrackingPropertyMacro.self,
        "TrackingIgnored": TrackingIgnoredMacro.self,
      ]
    ) {
      super.invokeTest()
    }
  }

  func test_did_set() {
    
    assertMacro {
      """
      struct MyState {
      
        @COWTrackingProperty      
        var stored_0: Int = 18 {
          didSet {
            print("stored_0 did set")
          }
        }
      
        @COWTrackingProperty      
        var stored_1: Int = 18 {
          willSet {
            print("stored_1 will set")
          }
          didSet {
            print("stored_1 did set")
          }
        }
      
        @COWTrackingProperty      
        var stored_2: Int = 18 {
          willSet {
            print("stored_2 will set")
          }      
        }
      
        internal let _tracking_context: _TrackingContext = .init()
          
      }
      """
    } expansion: {
      """
      struct MyState {


        var stored_0: Int {
          didSet {
            print("stored_0 did set")
          }
          _read {
            (_backing_stored_0.value as? TrackingObject)?._tracking_context.path = _tracking_context.path?.pushed(.init("stored_0"))
            _Tracking._tracking_modifyStorage {
              $0.accessorRead(path: _tracking_context.path?.pushed(.init("stored_0")))
            }
            yield _backing_stored_0.value
          }

          set {

            // willset
            do {
            }

            (_backing_stored_0.value as? TrackingObject)?._tracking_context.path = _tracking_context.path?.pushed(.init("stored_0"))
            _Tracking._tracking_modifyStorage {
              $0.accessorSet(path: _tracking_context.path?.pushed(.init("stored_0")))
            }
            if !isKnownUniquelyReferenced(&_backing_stored_0) {
              _backing_stored_0 = .init(newValue)
            } else {
              _backing_stored_0.value = newValue
            }

            // didSet 
            do {
                  print("stored_0 did set")
                }
          }

          _modify {
            (_backing_stored_0.value as? TrackingObject)?._tracking_context.path = _tracking_context.path?.pushed(.init("stored_0"))
            _Tracking._tracking_modifyStorage {
              $0.accessorModify(path: _tracking_context.path?.pushed(.init("stored_0")))
            }
            if !isKnownUniquelyReferenced(&_backing_stored_0) {
              _backing_stored_0 = .init(_backing_stored_0.value)
            }
            yield &_backing_stored_0.value

            // didSet   
            do {
                  print("stored_0 did set")
                }
          }
        }
          var _backing_stored_0: _BackingStorage<Int> = _BackingStorage.init(18)


        var stored_1: Int {
          willSet {
            print("stored_1 will set")
          }
          didSet {
            print("stored_1 did set")
          }
          _read {
            (_backing_stored_1.value as? TrackingObject)?._tracking_context.path = _tracking_context.path?.pushed(.init("stored_1"))
            _Tracking._tracking_modifyStorage {
              $0.accessorRead(path: _tracking_context.path?.pushed(.init("stored_1")))
            }
            yield _backing_stored_1.value
          }

          set {

            // willset
            do {
                  print("stored_1 will set")
                }

            (_backing_stored_1.value as? TrackingObject)?._tracking_context.path = _tracking_context.path?.pushed(.init("stored_1"))
            _Tracking._tracking_modifyStorage {
              $0.accessorSet(path: _tracking_context.path?.pushed(.init("stored_1")))
            }
            if !isKnownUniquelyReferenced(&_backing_stored_1) {
              _backing_stored_1 = .init(newValue)
            } else {
              _backing_stored_1.value = newValue
            }

            // didSet 
            do {
                  print("stored_1 did set")
                }
          }
        }
          var _backing_stored_1: _BackingStorage<Int> = _BackingStorage.init(18)


        var stored_2: Int {
          willSet {
            print("stored_2 will set")
          }      
          _read {
            (_backing_stored_2.value as? TrackingObject)?._tracking_context.path = _tracking_context.path?.pushed(.init("stored_2"))
            _Tracking._tracking_modifyStorage {
              $0.accessorRead(path: _tracking_context.path?.pushed(.init("stored_2")))
            }
            yield _backing_stored_2.value
          }

          set {

            // willset
            do {
                  print("stored_2 will set")
                }

            (_backing_stored_2.value as? TrackingObject)?._tracking_context.path = _tracking_context.path?.pushed(.init("stored_2"))
            _Tracking._tracking_modifyStorage {
              $0.accessorSet(path: _tracking_context.path?.pushed(.init("stored_2")))
            }
            if !isKnownUniquelyReferenced(&_backing_stored_2) {
              _backing_stored_2 = .init(newValue)
            } else {
              _backing_stored_2.value = newValue
            }

            // didSet 
            do {
            }
          }
        }
          var _backing_stored_2: _BackingStorage<Int> = _BackingStorage.init(18)

        internal let _tracking_context: _TrackingContext = .init()
          
      }
      """
    }
    
  }
  
  func test_optional_init() {
    assertMacro {
      """
      struct OptinalPropertyState {
        
        @COWTrackingProperty
        var stored_1: Int?
        
        init() {        
        }
        
      }
      """
    } expansion: {
      """
      struct OptinalPropertyState {

        var stored_1: Int? {
          
        @storageRestrictions(initializes: _backing_stored_1)
          
        init(initialValue) {
          
          _backing_stored_1 = .init(initialValue)
          
        }
          
        _read {
          
          (_backing_stored_1.value as? TrackingObject)?._tracking_context.path = _tracking_context.path?.pushed(.init("stored_1"))
          
          _Tracking._tracking_modifyStorage {
          
            $0.accessorRead(path: _tracking_context.path?.pushed(.init("stored_1")))
          
          }
          
          yield _backing_stored_1.value
          
        }
          
        set {

          
          // willset
          
          do {
          
          }

          
          (_backing_stored_1.value as? TrackingObject)?._tracking_context.path = _tracking_context.path?.pushed(.init("stored_1"))
          
          _Tracking._tracking_modifyStorage {
          
            $0.accessorSet(path: _tracking_context.path?.pushed(.init("stored_1")))
          
          }
          
          if !isKnownUniquelyReferenced(&_backing_stored_1) {
          
            _backing_stored_1 = .init(newValue)
          
          } else {
          
            _backing_stored_1.value = newValue
          
          }

          
          // didSet 
          
          do {
          
          }
          
        }
          
        _modify {
          
          (_backing_stored_1.value as? TrackingObject)?._tracking_context.path = _tracking_context.path?.pushed(.init("stored_1"))
          
          _Tracking._tracking_modifyStorage {
          
            $0.accessorModify(path: _tracking_context.path?.pushed(.init("stored_1")))
          
          }
          
          if !isKnownUniquelyReferenced(&_backing_stored_1) {
          
            _backing_stored_1 = .init(_backing_stored_1.value)
          
          }
          
          yield &_backing_stored_1.value

          
          // didSet   
          
          do {
          
          }
          
        }
        }
          var _backing_stored_1: _BackingStorage<Int?> = _BackingStorage.init(nil)
        
        init() {        
        }
        
      }
      """
    }
  }

  func test_macro() {

    assertMacro {
      """
      struct MyState {

        @COWTrackingProperty  
        private var stored_0: Int = 18

        @COWTrackingProperty  
        public var stored_1: Int = 18

        func compute() {
        }
      }
      """
    } expansion: {
      """
      struct MyState {


        private var stored_0: Int {
          _read {
            (_backing_stored_0.value as? TrackingObject)?._tracking_context.path = _tracking_context.path?.pushed(.init("stored_0"))
            _Tracking._tracking_modifyStorage {
              $0.accessorRead(path: _tracking_context.path?.pushed(.init("stored_0")))
            }
            yield _backing_stored_0.value
          }
          set {

            // willset
            do {
            }

            (_backing_stored_0.value as? TrackingObject)?._tracking_context.path = _tracking_context.path?.pushed(.init("stored_0"))
            _Tracking._tracking_modifyStorage {
              $0.accessorSet(path: _tracking_context.path?.pushed(.init("stored_0")))
            }
            if !isKnownUniquelyReferenced(&_backing_stored_0) {
              _backing_stored_0 = .init(newValue)
            } else {
              _backing_stored_0.value = newValue
            }

            // didSet 
            do {
            }
          }
          _modify {
            (_backing_stored_0.value as? TrackingObject)?._tracking_context.path = _tracking_context.path?.pushed(.init("stored_0"))
            _Tracking._tracking_modifyStorage {
              $0.accessorModify(path: _tracking_context.path?.pushed(.init("stored_0")))
            }
            if !isKnownUniquelyReferenced(&_backing_stored_0) {
              _backing_stored_0 = .init(_backing_stored_0.value)
            }
            yield &_backing_stored_0.value

            // didSet   
            do {
            }
          }
        }
          private var _backing_stored_0: _BackingStorage<Int> = _BackingStorage.init(18)


        public var stored_1: Int {
          _read {
            (_backing_stored_1.value as? TrackingObject)?._tracking_context.path = _tracking_context.path?.pushed(.init("stored_1"))
            _Tracking._tracking_modifyStorage {
              $0.accessorRead(path: _tracking_context.path?.pushed(.init("stored_1")))
            }
            yield _backing_stored_1.value
          }
          set {

            // willset
            do {
            }

            (_backing_stored_1.value as? TrackingObject)?._tracking_context.path = _tracking_context.path?.pushed(.init("stored_1"))
            _Tracking._tracking_modifyStorage {
              $0.accessorSet(path: _tracking_context.path?.pushed(.init("stored_1")))
            }
            if !isKnownUniquelyReferenced(&_backing_stored_1) {
              _backing_stored_1 = .init(newValue)
            } else {
              _backing_stored_1.value = newValue
            }

            // didSet 
            do {
            }
          }
          _modify {
            (_backing_stored_1.value as? TrackingObject)?._tracking_context.path = _tracking_context.path?.pushed(.init("stored_1"))
            _Tracking._tracking_modifyStorage {
              $0.accessorModify(path: _tracking_context.path?.pushed(.init("stored_1")))
            }
            if !isKnownUniquelyReferenced(&_backing_stored_1) {
              _backing_stored_1 = .init(_backing_stored_1.value)
            }
            yield &_backing_stored_1.value

            // didSet   
            do {
            }
          }
        }
          public var _backing_stored_1: _BackingStorage<Int> = _BackingStorage.init(18)

        func compute() {
        }
      }
      """
    }

  }
}
