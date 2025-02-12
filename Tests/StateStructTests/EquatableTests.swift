import Testing
import StateStruct

@Suite
struct EquatableTests {
  
  @Tracking
  struct DemoStruct: Equatable {
    
    var value: Int
    
  }

  @Test("Equatable")
  func test() {
    
    let a = DemoStruct.init(value: 1)
        
    let b = DemoStruct.init(value: 1)
    
    let c = DemoStruct.init(value: 2)
    
    #expect(a == b)
    #expect(a != c)
    
  }
  
  @Test
  func modifying() {
    
    var base = DemoStruct.init(value: 1)
    
    let original = base
    
    base.value = 2
    
    #expect(base != original)
  }
}
