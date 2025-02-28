import Testing
import StateStruct

@Suite("DidSet")
struct DidSetTests {
  
  struct NormalState {
    
    var count: Int = 0 {
      willSet { 
        willSet_count = newValue
      }
      didSet {
        didSet_count = count
      }
    }
    
    var didSet_count: Int = 0       
    var willSet_count: Int = 0
    
  }
  
  @Tracking
  struct TrackingState {
    
    var count: Int = 0 {
      willSet { 
//        willSet_count = newValue
      }
      didSet {
        didSet_count = count
      }
    }
    
    var didSet_count: Int = 0       
    var willSet_count: Int = 0
    
  }
  
  @Test
  func normal() {
    
    var value = NormalState()
    
    value.count = 1
    
    #expect(value.didSet_count == 1)
    #expect(value.willSet_count == 1)
  }
  
  @Test
  func tracking() {
    
    var value = TrackingState()
    
    value.count = 1
    
    #expect(value.didSet_count == 1)
    #expect(value.willSet_count == 1)
  
  }
}

