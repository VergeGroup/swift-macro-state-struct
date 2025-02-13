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
            (_backing_stored_0.value as? TrackingObject)?._tracking_context.path = _tracking_context.path?.pushed(.init("stored_0"))
            _Tracking._tracking_modifyStorage {
              $0.accessorSet(path: _tracking_context.path?.pushed(.init("stored_0")))
            }
            if !isKnownUniquelyReferenced(&_backing_stored_0) {
              _backing_stored_0 = .init(newValue)
            } else {
              _backing_stored_0.value = newValue
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
            (_backing_stored_1.value as? TrackingObject)?._tracking_context.path = _tracking_context.path?.pushed(.init("stored_1"))
            _Tracking._tracking_modifyStorage {
              $0.accessorSet(path: _tracking_context.path?.pushed(.init("stored_1")))
            }
            if !isKnownUniquelyReferenced(&_backing_stored_1) {
              _backing_stored_1 = .init(newValue)
            } else {
              _backing_stored_1.value = newValue
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
