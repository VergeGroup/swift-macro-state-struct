import StateStruct
import Testing

@Suite("TrackingTests")
struct TrackingTests {
  
  @Test
  func read_optional_custom_tyupe() {
    
    var original = MyState.init()
    
    original.startNewTracking()
    _ = original.optional_custom_type
    let result = original.trackingResult!
    
    original.endTracking()
            
    #expect(
      result.graph.prettyPrint() == """
        StateStructTests.MyState {
          optional_custom_type-(1)
        }
        """
    )
    
  }

  @Test
  func tracking_stored_property() {

    var original = MyState.init()

    original.startNewTracking()
    original.height = 100
    let result = original.trackingResult!
    
    original.endTracking()
    
    _ = original.name
    
    #expect(original.trackingResult == nil)

    #expect(
      result.graph.prettyPrint() == """
        StateStructTests.MyState {
          height+(1)
        }
        """
    )

  }

  @Test
  func tracking_write_nested_stored_property() {

    var original = MyState.init()

    original.startNewTracking()
    original.nested.name = "AAA"
    let result = original.trackingResult!

    #expect(
      result.graph.prettyPrint() == """
        StateStructTests.MyState {
          nested+(1) {
            name+(1)
          }
        }
        """
    )

  }
  
  @Test
  func tracking_write_nested_stored_property_escaping() async {
    
    let base = SendableState.init()
    
    do {
      var a = base.tracked()
      a.level1.name = "AAA"
      
      await Task {
        a.level1.level2.age = 100
      }
      .value
      
      let level2 = a.level1.level2
      
      await Task {
        _ = level2.name
      }
      .value
            
      let result = a.trackingResult!
      
      #expect(
        result.graph.prettyPrint() == 
      """
      StateStructTests.SendableState {
        level1-(1)+(2) {
          name+(1)
          level2-(1)+(1) {
            age+(1)
            name-(1)
          }
        }
      }
      """
      )
    }
    
    do {
      let a = base.tracked()
      _ = a.level1.name
      
      await Task {
        _ = a.level1.level2.age
      }
      .value
      
      let result = a.trackingResult!
      
      #expect(
        result.graph.prettyPrint() == 
      """
      StateStructTests.SendableState {
        level1-(2) {
          name-(1)
          level2-(1) {
            age-(1)
          }
        }
      }
      """
      )
    }
    
  }

  @Test
  func tracking_read_nested_stored_property() {

    var original = MyState.init()

    original.startNewTracking()
    _ = original.nested.name
    let result = original.trackingResult!

    #expect(
      result.graph.prettyPrint() == """
        StateStructTests.MyState {
          nested-(1) {
            name-(1)
          }
        }
        """
    )

  }

  @Test
  func read_computed_property() {

    var original = MyState.init()

    original.startNewTracking()
    _ = original.computedName
    let result = original.trackingResult!

    #expect(
      result.graph.prettyPrint() == """
        StateStructTests.MyState {
          name-(1)
        }
        """
    )

  }

  @Test
  func read_over_function() {
    var original = MyState.init()

    original.startNewTracking()
    _ = original.customDescription()
    let result = original.trackingResult!

    #expect(
      result.graph.prettyPrint() == """
        StateStructTests.MyState {
          height-(1)
          age-(1)
        }
        """
    )
  }

  @Test
  func tracking_nest() {

    var original = Nesting.init()

    original.startNewTracking()
    _ = original._1?._2?.value
    let result = original.trackingResult!

    #expect(
      result.graph.prettyPrint() == """
        StateStructTests.Nesting {
          _1-(1) {
            _2-(1) {
              value-(1)
            }
          }
        }
        """
    )
  }

  @Test
  func tracking_nest_set() {

    var original = Nesting.init()

    original.startNewTracking()
    original._1?._1?.value = "AAA"
    let result = original.trackingResult!

    #expect(
      result.graph.prettyPrint() == """
        StateStructTests.Nesting {
          _1+(1) {
            _1+(1) {
              value+(1)
            }
          }
        }
        """
    )
  }

  @Test
  func tracking_nest_detaching() {

    var original = Nesting.init()

    original.startNewTracking()
    let sub = original._1
    _ = sub?._1?.value
    let result = original.trackingResult!

    #expect(
      result.graph.prettyPrint() == """
        StateStructTests.Nesting {
          _1-(1) {
            _1-(1) {
              value-(1)
            }
          }
        }
        """
    )
  }

  @Test
  func tracking_nest_write_modify() {

    var original = Nesting.init()

    original.startNewTracking()
    original._1 = .init(_1: nil, _2: nil, _3: nil)
    let result = original.trackingResult!

    #expect(
      result.graph.prettyPrint() == """
        StateStructTests.Nesting {
          _1+(1)
        }
        """
    )
  }

  @Test
  func tracking_nest2_write_modify() {

    var original = Nesting.init()

    original.startNewTracking()
    original._1?._1 = .init(_1: nil, _2: nil, _3: nil)
    let result = original.trackingResult!

    #expect(
      result.graph.prettyPrint() == """
        StateStructTests.Nesting {
          _1+(1) {
            _1+(1)
          }
        }
        """
    )
  }

  @Test
  func tracking_1() {

    var original = Nesting.init()

    original.startNewTracking()
    _ = original._1?._1
    _ = original._1
    let result = original.trackingResult!

    #expect(
      result.graph.shakedAsRead().prettyPrint() == """
        StateStructTests.Nesting {
          _1-(2)
        }
        """
    )
  }

  @Test
  func tracking_nest_detaching_write() {

    var original = Nesting.init()

    original.startNewTracking()
    var sub = original._1
    sub?._1?.value = "AAA"
    var result = original.trackingResult!

    result.graph.shakeAsWrite()

    #expect(
      result.graph.prettyPrint() == """
        StateStructTests.Nesting
        """
    )
  }

  @Test
  func modify_endpoint() {

    var original = MyState.init()

    func update(_ value: inout String) {
      value = "AAA"
    }

    original.startNewTracking()
    update(&original.nested.name)
    let result = original.trackingResult!

    #expect(
      result.graph.prettyPrint() == """
        StateStructTests.MyState {
          nested+(1) {
            name+(1)
          }
        }
        """
    )
  }

  @Test
  func tracking_concurrent_access() async throws {

    try await withThrowingTaskGroup(of: Void.self) { group in
      group.addTask {
        var original = MyState.init()
        original.startNewTracking()
        original.height = 100
        let result1 = original.trackingResult!

        #expect(
          result1.graph.prettyPrint() == """
            StateStructTests.MyState {
              height+(1)
            }
            """
        )
      }

      group.addTask {
        var original = MyState.init()
        original.startNewTracking()
        original.nested.name = "AAA"
        let result2 = original.trackingResult!

        #expect(
          result2.graph.prettyPrint() == """
            StateStructTests.MyState {
              nested+(1) {
                name+(1)
              }
            }
            """
        )
      }

      try await group.waitForAll()
    }
  }

  @Test
  func write_is_empty() {

    var original = MyState.init()

    original.startNewTracking()
    _ = original.nested.name
    var nested = original.nested
    nested.name = "AAA"
    var result = original.trackingResult!

    result.graph.shakeAsWrite()

    result.graph.prettyPrint()

    #expect(
      result.graph.isEmpty == true
    )
  }

  @Test
  func modify_count() {

    var original = MyState.init()

    func update(_ value: inout MyState.Nested) {
      value.name = "AAA"
      value.name = "AAA"
      value.age = 100
    }

    original.startNewTracking()
    update(&original.nested)
    let result = original.trackingResult!

    #expect(
      result.graph.prettyPrint() == """
        StateStructTests.MyState {
          nested+(1) {
            name+(2)
            age+(1)
          }
        }
        """
    )
  }

  @Test
  func modify_count_1() {

    var original = MyState.init()

    func update(_ value: inout MyState.Nested) {
      value = .init(name: "AAA")
    }

    original.startNewTracking()
    update(&original.nested)
    let result = original.trackingResult!

    #expect(
      result.graph.prettyPrint() == """
        StateStructTests.MyState {
          nested+(1)
        }
        """
    )
  }

  @Test
  func modify_count_2() {

    var original = MyState.init()

    func update(_ value: inout MyState) {

    }

    original.startNewTracking()
    update(&original)
    let result = original.trackingResult!

    #expect(
      result.graph.prettyPrint() == """
        StateStructTests.MyState
        """
    )
  }

  @Test
  func referencing() {

    var tree = Tree(another: .init(wrappedValue: .init()))

    tree.startNewTracking()
    _ = tree.another?.value
    let result = tree.trackingResult!

    #expect(
      result.graph.prettyPrint() == """
        StateStructTests.Tree {
          another-(1) {
            wrappedValue-(1) {
              value-(1)
            }
          }
        }
        """
    )
  }
  
  @Test
  func weakRef() {
    
    var state = MyState.init()
    
    state.startNewTracking()
    _ = state.weak_ref
    let result = state.trackingResult!
    
    #expect(
      result.graph.prettyPrint() == """
        StateStructTests.MyState {
          weak_ref-(1)
        }
        """
    )
  }
}

@Tracking
struct AnotherTree {

  var value: Int = 0

}

@Tracking
struct Tree {

  var another: Referencing<AnotherTree>?

}
