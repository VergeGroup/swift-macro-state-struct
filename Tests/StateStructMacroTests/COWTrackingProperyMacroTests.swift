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
          get {
            return TrackingRuntime.processGet(
              component: .init("stored_0"),
              value: _backing_stored_0.value,
              trackingContext: _tracking_context
            )
          }

          set {

            // willset
            do {
            }

            _tracking_context.trackingResultRef?.accessorSet(path: _tracking_context.path?.pushed(.init("stored_0")))

            let oldValue = _backing_stored_0.value

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

            if !isKnownUniquelyReferenced(&_backing_stored_0) {
              _backing_stored_0 = .init(_backing_stored_0.value)
            }

            let oldValue = _backing_stored_0.value

            TrackingRuntime.processModify(
              component: .init("stored_0"),
              trackingContext: _tracking_context,
              storage: _backing_stored_0
            )

            yield &_backing_stored_0.value

            // didSet   
            do {
                  print("stored_0 did set")
                }
          }
        }
          var _backing_stored_0: _BackingStorage<Int> = _BackingStorage.init(18)

        internal var $stored_0: Referencing<Int> {
          Referencing(storage: _backing_stored_0)
        }


        var stored_1: Int {
          willSet {
            print("stored_1 will set")
          }
          didSet {
            print("stored_1 did set")
          }
          get {
            return TrackingRuntime.processGet(
              component: .init("stored_1"),
              value: _backing_stored_1.value,
              trackingContext: _tracking_context
            )
          }

          set {

            // willset
            do {
                  print("stored_1 will set")
                }

            _tracking_context.trackingResultRef?.accessorSet(path: _tracking_context.path?.pushed(.init("stored_1")))

            let oldValue = _backing_stored_1.value

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

        internal var $stored_1: Referencing<Int> {
          Referencing(storage: _backing_stored_1)
        }


        var stored_2: Int {
          willSet {
            print("stored_2 will set")
          }      
          get {
            return TrackingRuntime.processGet(
              component: .init("stored_2"),
              value: _backing_stored_2.value,
              trackingContext: _tracking_context
            )
          }

          set {

            // willset
            do {
                  print("stored_2 will set")
                }

            _tracking_context.trackingResultRef?.accessorSet(path: _tracking_context.path?.pushed(.init("stored_2")))



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

        internal var $stored_2: Referencing<Int> {
          Referencing(storage: _backing_stored_2)
        }

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
          
        get {
          
          return TrackingRuntime.processGet(
          
            component: .init("stored_1"),
          
            value: _backing_stored_1.value,
          
            trackingContext: _tracking_context
          
          )
          
        }
          
        set {

          
          // willset
          
          do {
          
          }

          
          _tracking_context.trackingResultRef?.accessorSet(path: _tracking_context.path?.pushed(.init("stored_1")))



          
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

          
          if !isKnownUniquelyReferenced(&_backing_stored_1) {
          
            _backing_stored_1 = .init(_backing_stored_1.value)
          
          }



          
          TrackingRuntime.processModify(
          
            component: .init("stored_1"),
          
            trackingContext: _tracking_context,
          
            storage: _backing_stored_1
          
          )

          
          yield &_backing_stored_1.value

          
          // didSet   
          
          do {
          
          }
          
        }
        }
          var _backing_stored_1: _BackingStorage<Int?> = _BackingStorage.init(nil)

        internal var $stored_1: Referencing<Int?> {
          Referencing(storage: _backing_stored_1)
        }
        
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
          get {
            return TrackingRuntime.processGet(
              component: .init("stored_0"),
              value: _backing_stored_0.value,
              trackingContext: _tracking_context
            )
          }
          set {

            // willset
            do {
            }

            _tracking_context.trackingResultRef?.accessorSet(path: _tracking_context.path?.pushed(.init("stored_0")))



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

            if !isKnownUniquelyReferenced(&_backing_stored_0) {
              _backing_stored_0 = .init(_backing_stored_0.value)
            }



            TrackingRuntime.processModify(
              component: .init("stored_0"),
              trackingContext: _tracking_context,
              storage: _backing_stored_0
            )

            yield &_backing_stored_0.value

            // didSet   
            do {
            }
          }
        }
          private var _backing_stored_0: _BackingStorage<Int> = _BackingStorage.init(18)

        private var $stored_0: Referencing<Int> {
          Referencing(storage: _backing_stored_0)
        }


        public var stored_1: Int {
          get {
            return TrackingRuntime.processGet(
              component: .init("stored_1"),
              value: _backing_stored_1.value,
              trackingContext: _tracking_context
            )
          }
          set {

            // willset
            do {
            }

            _tracking_context.trackingResultRef?.accessorSet(path: _tracking_context.path?.pushed(.init("stored_1")))



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

            if !isKnownUniquelyReferenced(&_backing_stored_1) {
              _backing_stored_1 = .init(_backing_stored_1.value)
            }



            TrackingRuntime.processModify(
              component: .init("stored_1"),
              trackingContext: _tracking_context,
              storage: _backing_stored_1
            )

            yield &_backing_stored_1.value

            // didSet   
            do {
            }
          }
        }
          public var _backing_stored_1: _BackingStorage<Int> = _BackingStorage.init(18)

        public var $stored_1: Referencing<Int> {
          Referencing(storage: _backing_stored_1)
        }

        func compute() {
        }
      }
      """
    }

  }
}
