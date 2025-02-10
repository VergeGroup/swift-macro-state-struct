# Dependency Tracking & Change Detection Test Documentation

This document outlines the detailed behavior observed from our test cases regarding dependency tracking and change detection in the state management system.

## 1. Dependency Tracking

The system provides a transactional tracking feature that records property access paths in both reading and writing modes. Every time a tracking block is executed using `state.tracking { ... }`, all property accesses performed within that block are automatically recorded into a dependency (or access) graph. This graph is structured hierarchically to represent exactly which properties—and even nested properties—were involved during the execution.

**Examples:**

- **Test 1:**  
  In the reading block, `state.height` is accessed, so the generated read graph includes a node for `height`. In the subsequent writing block, `state.height` is updated (set to 200), which produces a write graph that includes the same node. This precise tracking allows for a direct comparison between the two graphs.

- **Test 2:**  
  In the reading block, only `state.nested.name` is accessed, so the read graph specifically records the dependency path `nested → name`. Later, in the writing block, the entire `state.nested` object is replaced with a new instance. Even though the reading block explicitly accessed only `name`, the replacement of the entire `nested` object impacts the whole dependency chain and is duly captured in the write graph.

- **Additional Considerations:**  
  The tracking mechanism handles nested and optional property accesses effectively, ensuring that the entire access path is recorded accurately. This means that any modification affecting a part of a nested access chain can influence the overall dependency.

## 2. Change Detection Logic

After generating the read and write dependency graphs, the system uses the function `PropertyNode.hasChanges(writeGraph:readGraph:)` to determine whether any property that was read has been affected by a write operation.

This function compares the nodes between the two graphs:
- If a property that was read is directly modified or replaced in the write graph, the function reports that a change has occurred (returns `true`).
- If the modifications are outside of the read dependency, then no change is flagged (returns `false`).

**Examples:**

- **Test 1:**  
  Since the read graph includes `state.height` and the write operation directly updates `state.height`, the change detection function finds a matching node and returns `true`.

- **Test 2:**  
  Although the read graph only tracks `state.nested.name`, replacing the entire `state.nested` object in the writing block is sufficient to consider the dependency altered, and the function consequently returns `true`.

- **Test 3:**  
  Here, the read graph records a dependency on `state.nested.name`, but if the write block only modifies `state.nested.age`, then the property `name` remains unaffected. As a result, the function returns `false`.

This change detection logic ensures that only relevant modifications—those directly impacting the properties that were read—trigger further updates in the system. It prevents unnecessary processing by ignoring changes to properties that were not part of the initial dependency graph.