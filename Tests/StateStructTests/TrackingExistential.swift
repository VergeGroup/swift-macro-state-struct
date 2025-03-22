import Testing
import StateStruct

@Suite
struct TrackingExistential {

  @Tracking  
  struct UI {
    var count: Int
    
    init(count: Int) {
      self.count = count
    }
  }
  
  @Tracking
  struct Root {
    
    var _any: Any?
    
    var ui: UI? {
      get {
        _any as? UI
      }
      set {
        _any = newValue
      }
    }
    
    init(ui: UI) {
      self.ui = ui
    }
  }
  
  
  @Test func tracking() {
    
    var original = Root(ui: UI(count: 1))
    
    original.startNewTracking()
    _ = original.ui?.count
    let reading = original.trackingResult!
        
    #expect(
      reading.graph.prettyPrint() == """
        StateStructTests.TrackingExistential.Root {
          _any-(1) {
            count-(1)
          }
        }
        """
    )

  }
  
}
