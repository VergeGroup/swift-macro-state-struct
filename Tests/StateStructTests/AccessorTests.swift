import Testing

@Suite
struct AccessorTests {
  
  struct Container {
    
    var value: Int {
      _read {
        print("read")
        yield stored
      }
      set {
        print("set newValue: \(newValue)")
        stored = newValue
      }
      _modify {
        print("modify")
        yield &stored
      }
    }
    
    var stored: Int
    
  }
  
  @Test
  func modify() {

    func update(_ value: inout Int) {
      defer {
        print("defer")
      }
      print("update")
    }
    
    var container = Container.init(stored: 1)
    print("before")
    update(&container.value)
    print("after")
    
  }
}
