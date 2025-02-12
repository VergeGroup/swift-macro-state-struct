import MacroTesting
import StateStructMacros
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

final class TrackingMacroTests: XCTestCase {

  override func invokeTest() {
    withMacroTesting(
      record: false,
      macros: ["Tracking": TrackingMacro.self]
    ) {
      super.invokeTest()
    }
  }
  
  func test_public() {
    assertMacro {
      """
      @Tracking
      public struct MyState {
      
        private var stored_0: Int = 18
      
        var stored_1: String
      
        let stored_2: Int = 0
      
        var age: Int { 0 }
      
        var age2: Int {
          get { 0 }
          set { }
        }
      
        var height: Int
      
        func compute() {
        }
      }
      """
    } expansion: {
      """
      public struct MyState {
        @COWTrackingProperty

        private var stored_0: Int = 18
        @COWTrackingProperty

        var stored_1: String
        @COWTrackingProperty

        let stored_2: Int = 0

        var age: Int { 0 }

        var age2: Int {
          get { 0 }
          set { }
        }
        @COWTrackingProperty

        var height: Int

        func compute() {
        }

        public let _tracking_context: _TrackingContext = .init()
      }

      extension MyState: TrackingObject {
      }
      """
    }
  }

  func test_macro() {

    assertMacro {
      """
      @Tracking
      struct MyState {
      
        private var stored_0: Int = 18

        var stored_1: String
      
        let stored_2: Int = 0

        var age: Int { 0 }

        var age2: Int {
          get { 0 }
          set { }
        }

        var height: Int

        func compute() {
        }
      }
      """
    } expansion: {
      """
      struct MyState {
        @COWTrackingProperty

        private var stored_0: Int = 18
        @COWTrackingProperty

        var stored_1: String
        @COWTrackingProperty

        let stored_2: Int = 0

        var age: Int { 0 }

        var age2: Int {
          get { 0 }
          set { }
        }
        @COWTrackingProperty

        var height: Int

        func compute() {
        }

        internal let _tracking_context: _TrackingContext = .init()
      }

      extension MyState: TrackingObject {
      }
      """
    }

  }
}
