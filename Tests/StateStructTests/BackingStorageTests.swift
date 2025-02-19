import Testing
@testable import StateStruct

@Suite("CopyOnWrite Tests")
struct BackingStorageTests {
  
  @Test("Concurrent access should be thread-safe")
  func testConcurrentAccess() async throws {
    let storage = _BackingStorage(0)
    let iterations = 1000
    let taskCount = 10
    
    await withTaskGroup(of: Void.self) { group in
      for taskCount in 0..<taskCount {
        group.addTask {
          for i in 0..<iterations {
            print(i, taskCount)
            storage.value += 1
          }
        }
      }
      await group.waitForAll()
    }
    
    #expect(storage.value == iterations * taskCount)
  }
  
  @Test("Concurrent read-write operations should be safe")
  func testConcurrentReadWrite() async throws {
    let storage = _BackingStorage(0)
    let iterations = 1000
    
    async let writeTask: () = Task {
      for i in 0..<iterations {
        storage.value = i
      }
    }.value
    
    async let readTask: () = Task {
      for _ in 0..<iterations {
        #expect(storage.value >= 0)
      }
    }.value
    
    await writeTask
    await readTask
    
    #expect(storage.value == iterations - 1)
  }
  
  @Test("Copy on write behavior")
  func testCopyOnWrite() {
    let storage1 = _BackingStorage(42)
    let storage2 = storage1.copy()
    
    #expect(storage1.value == storage2.value)
    
    storage2.value = 100
    #expect(storage1.value == 42)
    #expect(storage2.value == 100)
  }
}
