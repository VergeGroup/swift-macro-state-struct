import StateStruct
import Testing

@Suite("UpdatingTests")
struct UpdatingTests {

  @Test
  func test_1() {

    var state = MyState()

    state.startNewTracking()
    _ = state.height
    let reading = state.trackingResult!

    state.startNewTracking()
    state.height = 200
    let writing = state.trackingResult!

    let hasChangesInReading = PropertyNode.hasChanges(
      writeGraph: writing.graph,
      readGraph: reading.graph
    )

    #expect(hasChangesInReading == true)
  }

  @Test
  func test_2() {

    var state = MyState()

    state.startNewTracking()
    _ = state.nested.name
    let reading = state.trackingResult!

    state.startNewTracking()
    state.nested = .init(name: "Foo")
    let writing = state.trackingResult!

    let hasChangesInReading = PropertyNode.hasChanges(
      writeGraph: writing.graph,
      readGraph: reading.graph
    )

    #expect(hasChangesInReading == true)
  }

  @Test
  func test_3() {

    var state = MyState()

    state.startNewTracking()
    _ = state.nested.name
    let reading = state.trackingResult!

    state.startNewTracking()
    state.nested.age = 100
    let writing = state.trackingResult!

    let hasChangesInReading = PropertyNode.hasChanges(
      writeGraph: writing.graph,
      readGraph: reading.graph
    )

    #expect(hasChangesInReading == false)
  }

  @Test("observing larger area than writing")
  func test_4() {

    var state = MyState()

    state.startNewTracking()
    _ = state.nested
    let reading = state.trackingResult!

    state.startNewTracking()
    state.nested.age = 100
    let writing = state.trackingResult!

    let hasChangesInReading = PropertyNode.hasChanges(
      writeGraph: writing.graph,
      readGraph: reading.graph
    )

    #expect(hasChangesInReading == true)
  }

  @Test
  func test_5() {

    var state = Nesting()

    state.startNewTracking()
    _ = state._1?.value
    _ = state._2?._1?.value
    _ = state._3?._2?.value
    let reading = state.trackingResult!

    print("reading", reading.graph.prettyPrint())

    state.startNewTracking()
    state._3?._2?.value = "3.2"
    let writing = state.trackingResult!

    let hasChangesInReading = PropertyNode.hasChanges(
      writeGraph: writing.graph,
      readGraph: reading.graph
    )

    #expect(hasChangesInReading == true)
  }

  @Test
  func test_6() {

    var state = Nesting()

    state.startNewTracking()
    _ = state._2
    _ = state._2?._1?.value
    var reading = state.trackingResult!

    reading.graph.shakeAsRead()

    print("reading", reading.graph.prettyPrint())

    state.startNewTracking()
    state._2?.value = "2.1"
    state._3?._2?.value = "3.2"
    let writing = state.trackingResult!

    let hasChangesInReading = PropertyNode.hasChanges(
      writeGraph: writing.graph,
      readGraph: reading.graph
    )

    #expect(hasChangesInReading == true)
  }

  @Test
  func test_7() {

    var state = Nesting()

    state.startNewTracking()
    _ = state._2
    _ = state._2?._1?.value
    let reading = state.trackingResult!

    print("reading", reading.graph.prettyPrint())

    state.startNewTracking()
    state._2?.value = "2.1"
    state._2 = .init()
    let writing = state.trackingResult!

    let hasChangesInReading = PropertyNode.hasChanges(
      writeGraph: writing.graph,
      readGraph: reading.graph
    )

    #expect(hasChangesInReading == true)
  }

  @Test
  func complex() {

    var original = Nesting.init()
    original.startNewTracking()
    let sub1 = original._1
    let sub2 = original._2
    let sub3 = original._3

    _ = sub1?._3?.value
    _ = sub1?._2?.value
    _ = sub1?._1?.value

    _ = sub2?._2?.value
    _ = sub2?._1?.value

    _ = sub3?._1?.value
    _ = sub3?._2?.value
    _ = sub3?._3?.value
    let result = original.trackingResult!

    print("👨🏻")

    #expect(
      result.graph.sorted().prettyPrint() == """
        StateStructTests.Nesting {
          _1-(1) {
            _1-(1) {
              value-(1)
            }
            _2-(1) {
              value-(1)
            }
            _3-(1) {
              value-(1)
            }
          }
          _2-(1) {
            _1-(1) {
              value-(1)
            }
            _2-(1) {
              value-(1)
            }
          }
          _3-(1) {
            _1-(1) {
              value-(1)
            }
            _2-(1) {
              value-(1)
            }
            _3-(1) {
              value-(1)
            }
          }
        }
        """
    )
  }

}
