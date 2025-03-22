import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacros

public struct PrimitiveTrackingPropertyMacro {
  
  public enum Error: Swift.Error {
    case needsTypeAnnotation
  }
  
}

extension PrimitiveTrackingPropertyMacro: PeerMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingPeersOf declaration: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    
    guard let variableDecl = declaration.as(VariableDeclSyntax.self) else {
      return []
    }
    
    guard variableDecl.typeSyntax != nil else {
      context.addDiagnostics(from: Error.needsTypeAnnotation, node: declaration)
      return []
    }
    
    var newMembers: [DeclSyntax] = []
    
    let ignoreMacroAttached = variableDecl.attributes.contains {
      switch $0 {
      case .attribute(let attribute):
        return attribute.attributeName.description == "TrackingIgnored"
      case .ifConfigDecl:
        return false
      }
    }
    
    guard !ignoreMacroAttached else {
      return []
    }
    
    for binding in variableDecl.bindings {
      if binding.accessorBlock != nil {
        // skip computed properties
        continue
      }
    }
    
    var _variableDecl = variableDecl.trimmed
    _variableDecl.attributes = [.init(.init(stringLiteral: "@TrackingIgnored"))]
    
    _variableDecl = _variableDecl.renamingIdentifier(with: "_backing_")
    
    newMembers.append(DeclSyntax(_variableDecl))
    
    return newMembers
  }
}

extension PrimitiveTrackingPropertyMacro: AccessorMacro {
  public static func expansion(
    of node: SwiftSyntax.AttributeSyntax,
    providingAccessorsOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
    in context: some SwiftSyntaxMacros.MacroExpansionContext
  ) throws -> [SwiftSyntax.AccessorDeclSyntax] {
    
    guard let variableDecl = declaration.as(VariableDeclSyntax.self) else {
      return []
    }
    
    guard let binding = variableDecl.bindings.first,
          let identifierPattern = binding.pattern.as(IdentifierPatternSyntax.self)
    else {
      return []
    }
    
    let isConstant = variableDecl.bindingSpecifier.tokenKind == .keyword(.let)
    let propertyName = identifierPattern.identifier.text
    let backingName = "_backing_" + propertyName
    let hasWillSet = variableDecl.willSetBlock != nil
    
    let initAccessor = AccessorDeclSyntax(
      """
      @storageRestrictions(initializes: \(raw: backingName))
      init(initialValue) {
        \(raw: backingName) = initialValue
      }
      """
    )
    
    let readAccessor = AccessorDeclSyntax(
      """
      _read {      
        let component = PropertyPath.Component.init("\(raw: propertyName)")
        _tracking_context.trackingResultRef?.accessorRead(path: _tracking_context.path?.pushed(component))

        yield \(raw: backingName)
      }
      """
    )
    
    let setAccessor = AccessorDeclSyntax(
      """
      set {       
        let component = PropertyPath.Component.init("\(raw: propertyName)")
        _tracking_context.trackingResultRef?.accessorSet(path: _tracking_context.path?.pushed(component))
      
        \(raw: backingName) = newValue         
      }
      """
    )
    
    let modifyAccessor = AccessorDeclSyntax(
      """
      _modify {
        let component = PropertyPath.Component.init("\(raw: propertyName)")
        _tracking_context.trackingResultRef?.accessorModify(path: _tracking_context.path?.pushed(component))
      
        yield &\(raw: backingName)
      }
      """
    )
    
    var accessors: [AccessorDeclSyntax] = []
    
    if binding.initializer == nil {
      accessors.append(initAccessor)
    }
    
    accessors.append(readAccessor)
    
    if !isConstant {
      accessors.append(setAccessor)
      
      if hasWillSet == false {
        accessors.append(modifyAccessor)
      }
    }
    
    return accessors
    
  }
  
}
