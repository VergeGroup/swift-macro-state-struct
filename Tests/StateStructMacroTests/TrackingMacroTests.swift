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

  func test_ignore_computed() {

    assertMacro {
      """
      @Tracking
      struct MyState {

        var c_0: Int {
          0
        }

        var c_1: Int {
          get { 0 }
        }

        var c_2: Int {
          get { 0 }
          set { }
        }
          
      }
      """
    } expansion: {
      """
      struct MyState {

        var c_0: Int {
          0
        }

        var c_1: Int {
          get { 0 }
        }

        var c_2: Int {
          get { 0 }
          set { }
        }

        internal let _tracking_context: _TrackingContext = .init()
          
      }

      extension MyState: TrackingObject {
      }
      """
    }

  }

  func test_stored_observer() {

    assertMacro {
      """
      @Tracking
      struct MyState {

        var stored_0: Int = 18 {
          didSet {
            print("stored_0 did set")
          }
        }
          
      }
      """
    } expansion: {
      """
      struct MyState {
        @COWTrackingProperty

        var stored_0: Int = 18 {
          didSet {
            print("stored_0 did set")
          }
        }

        internal let _tracking_context: _TrackingContext = .init()
          
      }

      extension MyState: TrackingObject {
      }
      """
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

  func test_weak_property() {

    assertMacro {
      """
      @Tracking
      struct MyState {

        weak var weak_stored: Ref?      

      }
      """
    } expansion: {
      """
      struct MyState {
        @WeakTrackingProperty

        weak var weak_stored: Ref?      

        internal let _tracking_context: _TrackingContext = .init()

      }

      extension MyState: TrackingObject {
      }
      """
    }

  }
}
