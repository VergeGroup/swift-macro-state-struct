import Testing

@Suite("Copy on Write")
struct CopyOnWriteTests {

  @Test
  func cow() {

    let original = MyState.init()

    var copy = original

    copy.height = 100

    #expect(copy.height == 100)
    #expect(original.height == 0)
  }

  @Test
  func cow_nested() {
    let original = MyState.init()
    var copy = original

    copy.nested.name = "AAA"

    #expect(copy.nested.name == "AAA")
    #expect(original.nested.name == "")
  }

  @Test
  func cow_array() {
    let original = MyState.init()
    var copy = original

    copy.array.append(1)

    #expect(copy.array == [1])
    #expect(original.array == [])
  }

  @Test
  func cow_optional() {
    let original = Nesting.init()
    var copy = original

    copy._1?._1?.value = "AAA"

    #expect(copy._1?._1?.value == "AAA")
    #expect(original._1?._1?.value == "")
  }
}
