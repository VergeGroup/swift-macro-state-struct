
enum KnownTypes {

  static func isCOWType(_ typeName: String) -> Bool {
    // Check if the type is a collection type with Copy-on-Write semantics
    func isArrayType(_ type: String) -> Bool {
      // Array<Type>形式または[Type]形式かチェック
      return (type.hasPrefix("Array<") && type.hasSuffix(">")) ||
             (type.hasPrefix("[") && type.hasSuffix("]") && !type.contains(":"))
    }
    
    func isDictionaryType(_ type: String) -> Bool {
      // Dictionary<KeyType, ValueType>形式または[KeyType: ValueType]形式かチェック
      return (type.hasPrefix("Dictionary<") && type.hasSuffix(">")) ||
             (type.hasPrefix("[") && type.hasSuffix("]") && type.contains(":"))
    }
    
    func isStringType(_ type: String) -> Bool {
      return type == "String"
    }
    
    func isSetType(_ type: String) -> Bool {
      return type.hasPrefix("Set<") && type.hasSuffix(">")
    }

    if isArrayType(typeName) {
      return true
    }
    
    if isDictionaryType(typeName) {
      return true
    }
    
    if isStringType(typeName) {
      return true
    }
    
    if isSetType(typeName) {
      return true
    }

    return false
  }
    // Integer types
  static let primitiveTypes: Set<String> = [
    // Integer types
    "Int",
    "Int8",
    "Int16",
    "Int32",
    "Int64",
    "UInt",
    "UInt8",
    "UInt16",
    "UInt32",
    "UInt64",
    
    // Floating-point types
    "Float",
    "Double",
    "CGFloat",
    
    // Boolean type
    "Bool",
    
    // Character types
    "Character",
    
    // Optional type
    "Optional",
    
    // Range types
    "Range",
    "ClosedRange",
    "PartialRangeFrom",
    "PartialRangeThrough",
    "PartialRangeUpTo",
    
    // Date types
    "Date",
    "TimeInterval",
    
    // UUID
    "UUID",
    
    // URL
    "URL",
    
    // Data
    "Data",
    
    // Decimal
    "Decimal",
    
    // CG types
    "CGPoint",
    "CGSize",
    "CGRect",
    "CGVector",
    
    // Color types
    "Color",
    "NSColor",
    "UIColor",
  ]
  
  static func isPrimitiveType(_ typeName: String) -> Bool {
    primitiveTypes.contains(typeName)
  }
} 
