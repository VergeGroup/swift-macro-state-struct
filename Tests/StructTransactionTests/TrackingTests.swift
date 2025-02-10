import StructTransaction
import Testing

@Suite("TrackingTests")
struct TrackingTests {

  @Test
  func tracking_stored_property() {

    var original = MyState.init()

    let result = original.tracking {
      original.height = 100
    }

    #expect(
      result.graph.prettyPrint() == """
        StructTransactionTests.MyState {
          height+(1)
        }
        """
    )

  }

  @Test
  func tracking_write_nested_stored_property() {

    var original = MyState.init()

    let result = original.tracking {
      original.nested.name = "AAA"
    }

    #expect(
      result.graph.prettyPrint() == """
        StructTransactionTests.MyState {
          nested+(1) {
            name+(1)
          }
        }
        """
    )

  }
  //
  @Test
  func tracking_read_nested_stored_property() {

    let original = MyState.init()

    let result = original.tracking {
      _ = original.nested.name
    }

    #expect(
      result.graph.prettyPrint() == """
        StructTransactionTests.MyState {
          nested-(1) {
            name-(1)
          }
        }
        """
    )

  }

  @Test
  func tracking_nest() {

    let original = Nesting.init()

    let result = original.tracking {
      _ = original._1?._2?.value
    }

    #expect(
      result.graph.prettyPrint() == """
        StructTransactionTests.Nesting {
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

    let result = original.tracking {
      original._1?._1?.value = "AAA"
    }

    #expect(
      result.graph.prettyPrint() == """
        StructTransactionTests.Nesting {
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

    let original = Nesting.init()

    let result = original.tracking {
      let sub = original._1

      _ = sub?._1?.value
    }

    #expect(
      result.graph.prettyPrint() == """
        StructTransactionTests.Nesting {
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

    let result = original.tracking {
      original._1 = .init(_1: nil, _2: nil, _3: nil)
    }

    #expect(
      result.graph.prettyPrint() == """
        StructTransactionTests.Nesting {
          _1+(1)
        }
        """
    )

  }

  @Test
  func tracking_nest2_write_modify() {

    var original = Nesting.init()

    let result = original.tracking {
      original._1?._1 = .init(_1: nil, _2: nil, _3: nil)
    }

    #expect(
      result.graph.prettyPrint() == """
        StructTransactionTests.Nesting {
          _1+(1) {
            _1+(1)
          }
        }
        """
    )

  }

  @Test
  func tracking_1() {
    
    let original = Nesting.init()
    
    let result = original.tracking {
      _ = original._1?._1
      _ = original._1
    }
    
    #expect(
      result.graph.shakedAsRead().prettyPrint() == """
        StructTransactionTests.Nesting {
          _1-(2)
        }
        """
    )
    
  }
  
  /**
   A case of detaching a nested object and then modifying it.
   which means the original object is not modified.
   */
  @Test
  func tracking_nest_detaching_write() {

    let original = Nesting.init()

    var result = original.tracking {
      var sub = original._1

      sub?._1?.value = "AAA"
    }

    result.graph.shakeAsWrite()

    #expect(
      result.graph.prettyPrint() == """
        StructTransactionTests.Nesting {
          _1-(1)
        }
        """
    )

  }

  @Test
  func modify_endpoint() {

    var original = MyState.init()

    func update(_ value: inout String) {
      value = "AAA"
    }

    let result = original.tracking {
      update(&original.nested.name)
    }

    #expect(
      result.graph.prettyPrint() == """
        StructTransactionTests.MyState {
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
        let result1 = original.tracking {
          original.height = 100
        }

        #expect(
          result1.graph.prettyPrint() == """
            StructTransactionTests.MyState {
              height+(1)
            }
            """
        )
      }

      group.addTask {
        var original = MyState.init()
        let result2 = original.tracking {
          original.nested.name = "AAA"
        }

        #expect(
          result2.graph.prettyPrint() == """
            StructTransactionTests.MyState {
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

}
