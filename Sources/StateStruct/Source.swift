/**
 Available only for structs
 */
@attached(
  memberAttribute
)
@attached(
  extension, conformances: TrackingObject, names: named(_tracking_propagate)
)
@attached(
  member, names: named(_tracking_context)
)
public macro Tracking() = #externalMacro(module: "StateStructMacros", type: "TrackingMacro")

@attached(
  accessor,
  names: named(willSet)
)
public macro TrackingIgnored() =
  #externalMacro(module: "StateStructMacros", type: "TrackingIgnoredMacro")

@attached(
  accessor,
  names: named(init), named(_read), named(set), named(_modify)
)
@attached(peer, names: prefixed(`_backing_`), prefixed(`$`))
public macro COWTrackingProperty() =
  #externalMacro(module: "StateStructMacros", type: "COWTrackingPropertyMacro")

@attached(
  accessor,
  names: named(init), named(_read), named(set), named(_modify)
)
@attached(peer, names: prefixed(`_backing_`))
public macro WeakTrackingProperty() =
  #externalMacro(module: "StateStructMacros", type: "WeakTrackingPropertyMacro")

#if DEBUG

  @Tracking
  struct OptinalPropertyState {

    var name: String
    var stored_1: Int?

    init() {
      self.name = ""
    }

  }

  @Tracking
  struct LetState {

    let stored_1: Int

    init(stored_1: Int) {
      self.stored_1 = stored_1
    }

  }

  @Tracking
  struct EquatableState: Equatable {
    var count: Int = 0
  }

  @Tracking
  struct HashableState: Hashable {
    var count: Int = 0
  }

  @Tracking
  struct MyState {

    init() {
      stored_2 = 0
    }

    var stored_1: Int = 18

    var stored_2: Int

    var stored_3: Int = 10 {
      didSet {
        print("stored_3 did set")
      }
    }

    var computed_1: Int {
      stored_1
    }

    var subState: MySubState = .init()

  }

  @Tracking
  struct MySubState {

    var stored_1: Int = 18

    var computed_1: Int {
      stored_1
    }
    
    weak var weak_stored: Ref?

    init() {

    }

  }

  class Ref {

  }

  #if canImport(Observation)
    import Observation

    @available(macOS 14.0, iOS 17.0, tvOS 15.0, watchOS 8.0, *)
    @Observable
    class Hoge {

      let stored: Int

      var stored_2: Int

      var stored_3: Int?

      weak var weak_stored: Hoge?

      var stored_4: Int = 10 {
        didSet {
          print("stored_4 did set")
        }
      }

      var name = ""

      init(stored: Int) {
        self.stored = stored
        self.stored_2 = stored
      }
    }
  #endif

#endif
