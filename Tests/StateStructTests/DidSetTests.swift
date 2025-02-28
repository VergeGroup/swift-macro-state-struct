import Testing
import StateStruct

@Suite("DidSet")
struct DidSetTests {
  
  @Tracking
  struct State {
    
    var count: Int = 0 {
      didSet {
        copy_count = count
      }
    }
    
    var copy_count: Int = 0       
    
  }
  
  @Test
  func example() {
    
    var value = State()
    
    value.count = 1
    
    #expect(value.copy_count == 1)
  
  }
}

