import Testing
import StateStruct

@Suite("GraphTests")
struct GraphTests {
  
  @Test
  func example() {
    
    var node = PropertyNode(name: "1")
    
    node.applyAsWrite(path: PropertyPath().pushed(.init("1")).pushed(.init("1")).pushed(.init("1")))
    node.applyAsWrite(path: PropertyPath().pushed(.init("1")).pushed(.init("2")).pushed(.init("1")))
    node.applyAsWrite(path: PropertyPath().pushed(.init("1")).pushed(.init("1")).pushed(.init("2")))
    
    print(node.prettyPrint())
    
    #expect(
      node.prettyPrint() ==
      """
      1 {
        1(0) {
          1+(1)
          2+(1)
        }
        2(0) {
          1+(1)
        }
      }
      """
    )
    
  }
  
}
