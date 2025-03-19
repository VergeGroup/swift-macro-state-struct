
extension Array {
  mutating func modify(_ modifier: (inout Element) -> Void) {
    for index in indices {
      modifier(&self[index])
    }
  }
}

