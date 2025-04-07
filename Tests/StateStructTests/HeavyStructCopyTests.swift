import Foundation
import StateStruct
import XCTest

// Heavy data structure with value types only
struct HeavyData {
  // Large data composed of multiple value-type fields
  var value1: Double = 1.0
  var value2: Double = 2.0
  var value3: Double = 3.0

  // Using tuples instead of arrays to avoid CoW optimizations
  var tuple1: (Double, Double, Double, Double, Double) = (0.0, 1.0, 2.0, 3.0, 4.0)
  var tuple2: (Double, Double, Double, Double, Double) = (5.0, 6.0, 7.0, 8.0, 9.0)
  var tuple3: (Double, Double, Double, Double, Double) = (10.0, 11.0, 12.0, 13.0, 14.0)
  var tuple4: (Double, Double, Double, Double, Double) = (15.0, 16.0, 17.0, 18.0, 19.0)
  var tuple5: (Double, Double, Double, Double, Double) = (20.0, 21.0, 22.0, 23.0, 24.0)
  var tuple6: (Double, Double, Double, Double, Double) = (25.0, 26.0, 27.0, 28.0, 29.0)
  var tuple7: (Double, Double, Double, Double, Double) = (30.0, 31.0, 32.0, 33.0, 34.0)
  var tuple8: (Double, Double, Double, Double, Double) = (35.0, 36.0, 37.0, 38.0, 39.0)
  var tuple9: (Double, Double, Double, Double, Double) = (40.0, 41.0, 42.0, 43.0, 44.0)
  var tuple10: (Double, Double, Double, Double, Double) = (45.0, 46.0, 47.0, 48.0, 49.0)

  // Large number of primitive value fields (flat structure)
  var v1: Double = 50.0
  var v2: Double = 51.0
  var v3: Double = 52.0
  var v4: Double = 53.0
  var v5: Double = 54.0
  var v6: Double = 55.0
  var v7: Double = 56.0
  var v8: Double = 57.0
  var v9: Double = 58.0
  var v10: Double = 59.0
  var v11: Double = 60.0
  var v12: Double = 61.0
  var v13: Double = 62.0
  var v14: Double = 63.0
  var v15: Double = 64.0
  var v16: Double = 65.0
  var v17: Double = 66.0
  var v18: Double = 67.0
  var v19: Double = 68.0
  var v20: Double = 69.0
  var v21: Double = 70.0
  var v22: Double = 71.0
  var v23: Double = 72.0
  var v24: Double = 73.0
  var v25: Double = 74.0
  var v26: Double = 75.0
  var v27: Double = 76.0
  var v28: Double = 77.0
  var v29: Double = 78.0
  var v30: Double = 79.0
  var v31: Double = 80.0
  var v32: Double = 81.0
  var v33: Double = 82.0
  var v34: Double = 83.0
  var v35: Double = 84.0
  var v36: Double = 85.0
  var v37: Double = 86.0
  var v38: Double = 87.0
  var v39: Double = 88.0
  var v40: Double = 89.0
  var v41: Double = 90.0
  var v42: Double = 91.0
  var v43: Double = 92.0
  var v44: Double = 93.0
  var v45: Double = 94.0
  var v46: Double = 95.0
  var v47: Double = 96.0
  var v48: Double = 97.0
  var v49: Double = 98.0
  var v50: Double = 99.0

  // Other properties
  var id: UUID = UUID()
  var name: String = "HeavyData"

  // This method accesses fields at runtime to prevent compiler optimizations
  func computeSum() -> Double {
    var sum = value1 + value2 + value3

    // Add tuple values
    sum += tuple1.0 + tuple1.1 + tuple1.2 + tuple1.3 + tuple1.4
    sum += tuple2.0 + tuple2.1 + tuple2.2 + tuple2.3 + tuple2.4
    sum += tuple3.0 + tuple3.1 + tuple3.2 + tuple3.3 + tuple3.4
    sum += tuple4.0 + tuple4.1 + tuple4.2 + tuple4.3 + tuple4.4
    sum += tuple5.0 + tuple5.1 + tuple5.2 + tuple5.3 + tuple5.4
    sum += tuple6.0 + tuple6.1 + tuple6.2 + tuple6.3 + tuple6.4
    sum += tuple7.0 + tuple7.1 + tuple7.2 + tuple7.3 + tuple7.4
    sum += tuple8.0 + tuple8.1 + tuple8.2 + tuple8.3 + tuple8.4
    sum += tuple9.0 + tuple9.1 + tuple9.2 + tuple9.3 + tuple9.4
    sum += tuple10.0 + tuple10.1 + tuple10.2 + tuple10.3 + tuple10.4

    // Add individual field values
    sum += v1 + v2 + v3 + v4 + v5 + v6 + v7 + v8 + v9 + v10
    sum += v11 + v12 + v13 + v14 + v15 + v16 + v17 + v18 + v19 + v20
    sum += v21 + v22 + v23 + v24 + v25 + v26 + v27 + v28 + v29 + v30
    sum += v31 + v32 + v33 + v34 + v35 + v36 + v37 + v38 + v39 + v40
    sum += v41 + v42 + v43 + v44 + v45 + v46 + v47 + v48 + v49 + v50

    return sum
  }
}

// Structure with multiple heavy value-type fields
struct ValueTypeStruct {
  var x: Int = 1
  var y: Int = 2
  var z: Int = 3

  // Multiple value-type fields to increase copy cost
  var vals: (Int, Int, Int, Int, Int, Int, Int, Int, Int, Int) = (0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
  var vals2: (Int, Int, Int, Int, Int, Int, Int, Int, Int, Int) = (
    10, 11, 12, 13, 14, 15, 16, 17, 18, 19
  )
  var vals3: (Int, Int, Int, Int, Int, Int, Int, Int, Int, Int) = (
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29
  )

  // Additional value-type fields
  var i1: Int = 30
  var i2: Int = 31
  var i3: Int = 32
  var i4: Int = 33
  var i5: Int = 34
  var i6: Int = 35
  var i7: Int = 36
  var i8: Int = 37
  var i9: Int = 38
  var i10: Int = 39
  var i11: Int = 40
  var i12: Int = 41
  var i13: Int = 42
  var i14: Int = 43
  var i15: Int = 44
  var i16: Int = 45
  var i17: Int = 46
  var i18: Int = 47
  var i19: Int = 48
  var i20: Int = 49
}

// Structure with high copy cost
struct HeavyStruct {
  // Property with large value-type data
  var mainData: HeavyData = HeavyData()

  // Nested value-type objects
  var valueStruct1: ValueTypeStruct = ValueTypeStruct()
  var valueStruct2: ValueTypeStruct = ValueTypeStruct()
  var valueStruct3: ValueTypeStruct = ValueTypeStruct()
  var valueStruct4: ValueTypeStruct = ValueTypeStruct()
  var valueStruct5: ValueTypeStruct = ValueTypeStruct()

  // Nested structures
  var nestedData1: NestedHeavyData = NestedHeavyData()
  var nestedData2: NestedHeavyData = NestedHeavyData()
  var nestedData3: NestedHeavyData = NestedHeavyData()

  // Nested structure with large data
  struct NestedHeavyData {
    var nestedValueStruct1: ValueTypeStruct = ValueTypeStruct()
    var nestedValueStruct2: ValueTypeStruct = ValueTypeStruct()
    var nestedValueStruct3: ValueTypeStruct = ValueTypeStruct()

    // Value-type tuples
    var tuple1: (Int, Int, Int, Int) = (1, 2, 3, 4)
    var tuple2: (Int, Int, Int, Int) = (5, 6, 7, 8)
    var tuple3: (Int, Int, Int, Int) = (9, 10, 11, 12)
    var tuple4: (Int, Int, Int, Int) = (13, 14, 15, 16)
    var tuple5: (Int, Int, Int, Int) = (17, 18, 19, 20)

    // Individual value-type fields
    var a1: Int = 21
    var a2: Int = 22
    var a3: Int = 23
    var a4: Int = 24
    var a5: Int = 25
    var a6: Int = 26
    var a7: Int = 27
    var a8: Int = 28
    var a9: Int = 29
    var a10: Int = 30
    var a11: Int = 31
    var a12: Int = 32
    var a13: Int = 33
    var a14: Int = 34
    var a15: Int = 35
    var a16: Int = 36
    var a17: Int = 37
    var a18: Int = 38
    var a19: Int = 39
    var a20: Int = 40

    // This method accesses values to prevent compiler optimizations
    func accessValues() -> Int {
      var sum = 0

      // Add tuple values
      sum += tuple1.0 + tuple1.1 + tuple1.2 + tuple1.3
      sum += tuple2.0 + tuple2.1 + tuple2.2 + tuple2.3
      sum += tuple3.0 + tuple3.1 + tuple3.2 + tuple3.3
      sum += tuple4.0 + tuple4.1 + tuple4.2 + tuple4.3
      sum += tuple5.0 + tuple5.1 + tuple5.2 + tuple5.3

      // Add individual field values
      sum += a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8 + a9 + a10
      sum += a11 + a12 + a13 + a14 + a15 + a16 + a17 + a18 + a19 + a20

      sum += nestedValueStruct1.x + nestedValueStruct2.y + nestedValueStruct3.z
      return sum
    }
  }
}

// Version with @Tracking macro
@Tracking
struct TrackedHeavyStruct {
  // Property with large value-type data
  var mainData: HeavyData = HeavyData()

  // Nested value-type objects
  var valueStruct1: ValueTypeStruct = ValueTypeStruct()
  var valueStruct2: ValueTypeStruct = ValueTypeStruct()
  var valueStruct3: ValueTypeStruct = ValueTypeStruct()
  var valueStruct4: ValueTypeStruct = ValueTypeStruct()
  var valueStruct5: ValueTypeStruct = ValueTypeStruct()

  // Nested structures
  var nestedData1: NestedHeavyData = NestedHeavyData()
  var nestedData2: NestedHeavyData = NestedHeavyData()
  var nestedData3: NestedHeavyData = NestedHeavyData()

  // Nested structure with large data
  @Tracking
  struct NestedHeavyData {
    var nestedValueStruct1: ValueTypeStruct = ValueTypeStruct()
    var nestedValueStruct2: ValueTypeStruct = ValueTypeStruct()
    var nestedValueStruct3: ValueTypeStruct = ValueTypeStruct()

    // Value-type tuples
    var tuple1: (Int, Int, Int, Int) = (1, 2, 3, 4)
    var tuple2: (Int, Int, Int, Int) = (5, 6, 7, 8)
    var tuple3: (Int, Int, Int, Int) = (9, 10, 11, 12)
    var tuple4: (Int, Int, Int, Int) = (13, 14, 15, 16)
    var tuple5: (Int, Int, Int, Int) = (17, 18, 19, 20)

    // Individual value-type fields
    var a1: Int = 21
    var a2: Int = 22
    var a3: Int = 23
    var a4: Int = 24
    var a5: Int = 25
    var a6: Int = 26
    var a7: Int = 27
    var a8: Int = 28
    var a9: Int = 29
    var a10: Int = 30
    var a11: Int = 31
    var a12: Int = 32
    var a13: Int = 33
    var a14: Int = 34
    var a15: Int = 35
    var a16: Int = 36
    var a17: Int = 37
    var a18: Int = 38
    var a19: Int = 39
    var a20: Int = 40

    // This method accesses values to prevent compiler optimizations
    func accessValues() -> Int {
      var sum = 0

      // Add tuple values
      sum += tuple1.0 + tuple1.1 + tuple1.2 + tuple1.3
      sum += tuple2.0 + tuple2.1 + tuple2.2 + tuple2.3
      sum += tuple3.0 + tuple3.1 + tuple3.2 + tuple3.3
      sum += tuple4.0 + tuple4.1 + tuple4.2 + tuple4.3
      sum += tuple5.0 + tuple5.1 + tuple5.2 + tuple5.3

      // Add individual field values
      sum += a1 + a2 + a3 + a4 + a5 + a6 + a7 + a8 + a9 + a10
      sum += a11 + a12 + a13 + a14 + a15 + a16 + a17 + a18 + a19 + a20

      sum += nestedValueStruct1.x + nestedValueStruct2.y + nestedValueStruct3.z
      return sum
    }
  }
}

class HeavyStructCopyTests: XCTestCase {

  // Setup before test execution
  override func setUp() {
    super.setUp()
    // Add initialization code if needed
  }

  // Cleanup after test execution
  override func tearDown() {
    // Add cleanup code if needed
    super.tearDown()
  }

  // Measure copy performance of regular struct
  func testHeavyStructCopy() {
    let original = HeavyStruct()

    measure {
      // Copy the struct
      var copy = original
      // Make changes to prevent optimizations
      copy.mainData.name = "Modified"

      // Verify changes are correctly reflected
      XCTAssertEqual(copy.mainData.name, "Modified")
      XCTAssertEqual(original.mainData.name, "HeavyData")
    }
  }

  // Measure copy performance of @Tracking struct
  func testTrackedHeavyStructCopy() {
    let original = TrackedHeavyStruct()

    measure {
      // Copy the struct
      var copy = original
      // Make changes to prevent optimizations
      copy.mainData.name = "Modified"

      // Verify changes are correctly reflected
      XCTAssertEqual(copy.mainData.name, "Modified")
      XCTAssertEqual(original.mainData.name, "HeavyData")
    }
  }

  // Measure performance of multiple copies with regular struct
  func testMultipleHeavyStructCopies() {
    let original = HeavyStruct()
    let iterations = 10

    measure {
      for _ in 0..<iterations {
        var copy = original
        copy.valueStruct1.x += 1
        // Ensure changes are made (prevents optimization)
        XCTAssertTrue(copy.valueStruct1.x > original.valueStruct1.x)
      }
    }
  }

  // Measure performance of multiple copies with @Tracking struct
  func testMultipleTrackedHeavyStructCopies() {
    let original = TrackedHeavyStruct()
    let iterations = 10

    measure {
      for _ in 0..<iterations {
        var copy = original
        copy.valueStruct1.x += 1
        // Ensure changes are made (prevents optimization)
        XCTAssertTrue(copy.valueStruct1.x > original.valueStruct1.x)
      }
    }
  }

  // Measure performance of deep nested property modification in regular struct
  func testDeepNestedModificationRegular() {
    let original = HeavyStruct()

    measure {
      var copy = original
      // Modify deeply nested property
      copy.nestedData1.nestedValueStruct3.vals3.9 = 999

      XCTAssertEqual(copy.nestedData1.nestedValueStruct3.vals3.9, 999)
      XCTAssertEqual(original.nestedData1.nestedValueStruct3.vals3.9, 29)
    }
  }

  // Measure performance of deep nested property modification in @Tracking struct
  func testDeepNestedModificationTracked() {
    let original = TrackedHeavyStruct()

    measure {
      var copy = original
      // Modify deeply nested property
      copy.nestedData1.nestedValueStruct3.vals3.9 = 999

      XCTAssertEqual(copy.nestedData1.nestedValueStruct3.vals3.9, 999)
      XCTAssertEqual(original.nestedData1.nestedValueStruct3.vals3.9, 29)
    }
  }

  // Measure performance of multiple property modifications in regular struct
  func testMultipleModificationsRegular() {
    let original = HeavyStruct()

    measure {
      var copy = original

      // Modify multiple properties
      copy.valueStruct1.x = 100
      copy.valueStruct2.y = 200
      copy.valueStruct3.z = 300
      copy.nestedData1.nestedValueStruct1.x = 400
      copy.nestedData2.nestedValueStruct2.y = 500

      // Verify changes are correctly reflected
      XCTAssertEqual(copy.valueStruct1.x, 100)
      XCTAssertEqual(copy.nestedData1.nestedValueStruct1.x, 400)

      XCTAssertEqual(original.valueStruct1.x, 1)
      XCTAssertEqual(original.nestedData1.nestedValueStruct1.x, 1)
    }
  }

  // Measure performance of multiple property modifications in @Tracking struct
  func testMultipleModificationsTracked() {
    let original = TrackedHeavyStruct()

    measure {
      var copy = original

      // Modify multiple properties
      copy.valueStruct1.x = 100
      copy.valueStruct2.y = 200
      copy.valueStruct3.z = 300
      copy.nestedData1.nestedValueStruct1.x = 400
      copy.nestedData2.nestedValueStruct2.y = 500

      // Verify changes are correctly reflected
      XCTAssertEqual(copy.valueStruct1.x, 100)
      XCTAssertEqual(copy.nestedData1.nestedValueStruct1.x, 400)

      XCTAssertEqual(original.valueStruct1.x, 1)
      XCTAssertEqual(original.nestedData1.nestedValueStruct1.x, 1)
    }
  }

  // Measure property access performance after copy for regular struct
  func testPropertyAccessAfterCopyRegular() {
    let original = HeavyStruct()
    var copy = original

    // Initial modification
    copy.valueStruct1.x = 100

    measure {
      // Access multiple properties
      let val1 = copy.valueStruct1.x
      let val2 = copy.valueStruct2.y
      let val3 = copy.nestedData1.nestedValueStruct3.z
      let val4 = copy.nestedData2.a10

      // Assertions to prevent optimization
      XCTAssertEqual(val1, 100)
      XCTAssertEqual(val2, 2)
      XCTAssertEqual(val3, 3)
      XCTAssertEqual(val4, 30)
    }
  }

  // Measure property access performance after copy for @Tracking struct
  func testPropertyAccessAfterCopyTracked() {
    let original = TrackedHeavyStruct()
    var copy = original

    // Initial modification
    copy.valueStruct1.x = 100

    measure {
      // Access multiple properties
      let val1 = copy.valueStruct1.x
      let val2 = copy.valueStruct2.y
      let val3 = copy.nestedData1.nestedValueStruct3.z
      let val4 = copy.nestedData2.a10

      // Assertions to prevent optimization
      XCTAssertEqual(val1, 100)
      XCTAssertEqual(val2, 2)
      XCTAssertEqual(val3, 3)
      XCTAssertEqual(val4, 30)
    }
  }

  // 複数回のコピー生成のパフォーマンスを測定（通常の構造体）
  func testMultipleCopiesRegular() {
    let original = HeavyStruct()

    measure {
      for _ in 0..<100000 {        
        var copy1 = original
        var copy2 = copy1
        var copy3 = copy2
        var copy4 = copy3
        var copy5 = copy4
      }
    
    }
  }

  // 複数回のコピー生成のパフォーマンスを測定（@Tracking構造体）
  func testMultipleCopiesTracked() {
    let original = TrackedHeavyStruct()

    measure {
      for _ in 0..<100000 {        
        var copy1 = original
        var copy2 = copy1
        var copy3 = copy2
        var copy4 = copy3
        var copy5 = copy4
      }   
    }
  }
}
