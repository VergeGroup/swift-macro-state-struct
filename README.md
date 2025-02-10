# StateStruct - `@Tracking` macro

## Introduction
StateStruct is a Swift library designed to simplify state management within structs by implementing dependency tracking and change detection. It leverages Swift macros and compiler plugins to automatically inject tracking code into property reads and writes, constructing dependency graphs that reveal how properties interact and change during execution.

## Main Features

### Dependency Tracking
- **@Tracking Macro:** Automatically integrates tracking code to monitor property accesses.
  - **Read Operations:** When properties are read within a tracking block, their access paths (via PropertyPath objects) are recorded into the read dependency graph.
  - **Write Operations:** Similarly, modifications to properties are logged in the write dependency graph.

### Change Detection
- By using the function `PropertyNode.hasChanges(writeGraph:readGraph:)`, StateStruct compares read and write dependency graphs to determine if any previously accessed property has changed. This ensures that only pertinent changes trigger reactive updates, avoiding unnecessary processing.

### Swift Macros
- Swift macro technology simplifies the insertion of tracking code into structs. This reduces boilerplate and ensures consistent monitoring of property accesses.

### Copy-on-Write (COW) Support
- The library implements a copy-on-write (COW) mechanism to optimize state updates. Since the state is structured as a Swift struct and modifications occur frequently, this mechanism ensures that copies are created only when necessary. This optimizes performance by preventing unnecessary data duplication and avoiding inadvertent side effects from shared mutable state. Components like the _BackingStorage class effectively manage this process.

### Nested State Support
- StateStruct reliably tracks dependencies and detects changes for both flat properties and deeply nested structures (e.g., state.nested.name).

## Usage Example

```swift
import StateStruct

@Tracking
struct MyState {
    var height: Int = 0
    var name: String = ""
    var nested: Nested = .init(name: "")

    struct Nested {
        var name: String = ""
        var age: Int = 18
    }
}

var state = MyState()

// Tracking read operations
let readTracking = state.tracking {
    _ = state.height
    _ = state.nested.name
}

// Tracking write operations
let writeTracking = state.tracking {
    state.height = 200
}

// Change detection: compare dependency graphs to determine if a change occurred
let hasChanged = PropertyNode.hasChanges(
    writeGraph: writeTracking.graph,
    readGraph: readTracking.graph
)

// Output: true

```

Test Cases in UpdatingTests.swift:

1. Nested Property Access and Modification
   ```swift
   // Reading nested.name
   let reading = state.tracking {
     _ = state.nested.name  
   }
   
   // Writing to nested.name
   let writing = state.tracking {
     state.nested = .init(name: "Foo")
   }
   // Result: Change detected ✅
   ```

2. Unrelated Property Changes
   ```swift
   // Reading nested.name
   let reading = state.tracking {
     _ = state.nested.name
   }
   
   // Writing to unrelated nested.age
   let writing = state.tracking {
     state.nested.age = 100  
   }
   // Result: No change detected ❌
   ```

3. Broad vs Narrow Tracking
   ```swift
   // Reading entire nested object
   let reading = state.tracking {
     _ = state.nested // Tracks all nested properties
   }
   
   // Writing to one nested field
   let writing = state.tracking {
     state.nested.age = 100
   }
   // Result: Change detected ✅ (since we're watching all of nested)
   ```

Each test case demonstrates how StateStruct intelligently tracks dependencies and detects changes in nested structures. The examples show real code snippets from the test suite with clear expected outcomes.

