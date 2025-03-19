import StateStruct

@Tracking
struct Nesting {

  var value: String = ""

  var _1: Nesting? = nil

  var _2: Nesting? = nil

  var _3: Nesting? = nil

  init(_1: Nesting?, _2: Nesting?, _3: Nesting?) {
    self._1 = _1
    self._2 = _2
    self._3 = _3
  }

  init() {
    self.value = "root"
    self._1 = Nesting.init(
      _1: .init(
        _1: .init(
          _1: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _2: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _3: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          )
        ),
        _2: .init(
          _1: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _2: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _3: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          )
        ),
        _3: .init(
          _1: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _2: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _3: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          )
        )
      ),
      _2: .init(
        _1: .init(
          _1: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _2: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _3: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          )
        ),
        _2: .init(
          _1: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _2: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _3: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          )
        ),
        _3: .init(
          _1: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _2: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _3: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          )
        )
      ),
      _3: .init(
        _1: .init(
          _1: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _2: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _3: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          )
        ),
        _2: .init(
          _1: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _2: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _3: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          )
        ),
        _3: .init(
          _1: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _2: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _3: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          )
        )
      )
    )
    
    self._2 = Nesting.init(
      _1: .init(
        _1: .init(
          _1: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _2: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _3: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          )
        ),
        _2: .init(
          _1: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _2: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _3: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          )
        ),
        _3: .init(
          _1: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _2: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _3: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          )
        )
      ),
      _2: .init(
        _1: .init(
          _1: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _2: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _3: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          )
        ),
        _2: .init(
          _1: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _2: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _3: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          )
        ),
        _3: .init(
          _1: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _2: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _3: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          )
        )
      ),
      _3: .init(
        _1: .init(
          _1: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _2: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _3: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          )
        ),
        _2: .init(
          _1: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _2: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _3: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          )
        ),
        _3: .init(
          _1: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _2: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _3: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          )
        )
      )
    )
    
    self._3 = Nesting.init(
      _1: .init(
        _1: .init(
          _1: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _2: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _3: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          )
        ),
        _2: .init(
          _1: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _2: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _3: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          )
        ),
        _3: .init(
          _1: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _2: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _3: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          )
        )
      ),
      _2: .init(
        _1: .init(
          _1: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _2: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _3: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          )
        ),
        _2: .init(
          _1: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _2: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _3: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          )
        ),
        _3: .init(
          _1: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _2: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _3: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          )
        )
      ),
      _3: .init(
        _1: .init(
          _1: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _2: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _3: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          )
        ),
        _2: .init(
          _1: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _2: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _3: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          )
        ),
        _3: .init(
          _1: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _2: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          ),
          _3: .init(
            _1: .init(_1: nil, _2: nil, _3: nil),
            _2: .init(_1: nil, _2: nil, _3: nil),
            _3: .init(_1: nil, _2: nil, _3: nil)
          )
        )
      )
    )
  }
}

class Ref {
  
}

@Tracking
struct SendableState: Sendable {
  
  @Tracking
  struct Level1 {
    
    init(name: String) {
      self.name = name
    }
    
    var level2: Level2 = .init(name: "")
    var name: String = ""
    var age: Int = 10
  }
  
  @Tracking
  struct Level2 {
    
    init(name: String) {
      self.name = name
    }
    
    var name: String = ""
    var age: Int = 10
  }
  
  var level1: Level1 = .init(name: "A")
  
  init() {
    
  }
      
}

@Tracking
struct MyState {

  init() {
    self.name = ""
  }
  
  func customDescription() -> String {
    "\(height),\(age)"
  }
    
  var height: Int = 0

  var age: Int = 18
  var name: String

  var edge: Int = 0
  
  var array: [Int] = []
  
  var dictionary: [String: Int] = [:]

  var computedName: String {
    "Mr. " + name
  }
  
  weak var weak_ref: Ref?

  var computedAge: Int {
    let age = age
    return age
  }

  var computed_setter: String {
    get {
      name
    }
    set {
      name = newValue
    }
  }

  var nested: Nested = .init(name: "")
  var nestedAttached: NestedAttached = .init(name: "")

  @Tracking
  struct Nested {

    init(name: String) {
      self.name = name
    }

    var name: String = ""
    var age: Int = 10
  }

  struct NestedAttached {
    var name: String = ""
  }

  mutating func updateName() {
    self.name = "Hiroshi"
  }

}
