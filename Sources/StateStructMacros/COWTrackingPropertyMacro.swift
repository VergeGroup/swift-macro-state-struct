import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacroExpansion

public struct COWTrackingPropertyMacro {

}

extension COWTrackingPropertyMacro: PeerMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingPeersOf declaration: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {

    guard let variableDecl = declaration.as(VariableDeclSyntax.self) else {
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

    _variableDecl = _variableDecl
      .renamingIdentifier(with: "_backing_")
      .modifyingTypeAnnotation({ type in
        return "_BackingStorage<\(type.trimmed)>"
      })
      .modifyingInit({ initializer in                
        return .init(value: "_BackingStorage.init(\(initializer.value))" as ExprSyntax)        
      })
    
    newMembers.append(DeclSyntax(_variableDecl))

    return newMembers
  }
}

extension COWTrackingPropertyMacro: AccessorMacro {
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

    let initAccessor = AccessorDeclSyntax(
      """
      @storageRestrictions(initializes: \(raw: backingName))
      init(initialValue) {
        \(raw: backingName) = .init(initialValue)
      }
      """
    )
    
    let readAccessor = AccessorDeclSyntax(
      """
      _read {
        (\(raw: backingName).value as? TrackingObject)?._tracking_context.path = _tracking_context.path?.pushed(.init("\(raw: propertyName)"))
        _Tracking._tracking_modifyStorage {
          $0.accessorRead(path: _tracking_context.path?.pushed(.init("\(raw: propertyName)")))
        }
        yield \(raw: backingName).value    
      }
      """
    )

    let setAccessor = AccessorDeclSyntax(
      """
      set {      
        (\(raw: backingName).value as? TrackingObject)?._tracking_context.path = _tracking_context.path?.pushed(.init("\(raw: propertyName)"))
        _Tracking._tracking_modifyStorage {
          $0.accessorSet(path: _tracking_context.path?.pushed(.init("\(raw: propertyName)")))
        }
        if !isKnownUniquelyReferenced(&\(raw: backingName)) {
          \(raw: backingName) = .init(newValue)
        } else {
          \(raw: backingName).value = newValue
        }
      
      }
      """
    )

    let modifyAccessor = AccessorDeclSyntax(
      """
      _modify {
        (\(raw: backingName).value as? TrackingObject)?._tracking_context.path = _tracking_context.path?.pushed(.init("\(raw: propertyName)"))
        _Tracking._tracking_modifyStorage {
          $0.accessorModify(path: _tracking_context.path?.pushed(.init("\(raw: propertyName)")))
        }
        if !isKnownUniquelyReferenced(&\(raw: backingName)) {
          \(raw: backingName) = .init(\(raw: backingName).value)
        }
        yield &\(raw: backingName).value
      }
      """
    )
    
    var accessors: [AccessorDeclSyntax] = []
       
    accessors.append(readAccessor)
    if !isConstant {
      accessors.append(setAccessor)      
      accessors.append(modifyAccessor)
    }
    if binding.initializer == nil {
      accessors.append(initAccessor)
    }

    return accessors

  }

}

extension VariableDeclSyntax {
  func renamingIdentifier(with newName: String) -> VariableDeclSyntax {
    let newBindings = self.bindings.map { binding -> PatternBindingSyntax in
      
      if let identifierPattern = binding.pattern.as(IdentifierPatternSyntax.self) {
        
        let propertyName = identifierPattern.identifier.text
        
        let newIdentifierPattern = identifierPattern.with(
          \.identifier, "\(raw: newName)\(raw: propertyName)")
        return binding.with(\.pattern, .init(newIdentifierPattern))
      }
      return binding
    }
    
    return self.with(\.bindings, .init(newBindings))
  }
}

extension VariableDeclSyntax {
  func withPrivateModifier() -> VariableDeclSyntax {
    
    let privateModifier = DeclModifierSyntax.init(
      name: .keyword(.private), trailingTrivia: .spaces(1))
    
    var modifiers = self.modifiers
    if modifiers.contains(where: { $0.name.tokenKind == .keyword(.private) }) {
      return self
    }
    modifiers.append(privateModifier)
    return self.with(\.modifiers, modifiers)
  }
}

extension VariableDeclSyntax {
  
  func modifyingTypeAnnotation(_ modifier: (TypeSyntax) -> TypeSyntax) -> VariableDeclSyntax {
    let newBindings = self.bindings.map { binding -> PatternBindingSyntax in
      if let typeAnnotation = binding.typeAnnotation {
        let newType = modifier(typeAnnotation.type)
        let newTypeAnnotation = typeAnnotation.with(\.type, newType)
        return binding.with(\.typeAnnotation, newTypeAnnotation)
      }
      return binding
    }
    
    return self.with(\.bindings, .init(newBindings))
  }
  
  func modifyingInit(_ modifier: (InitializerClauseSyntax) -> InitializerClauseSyntax) -> VariableDeclSyntax {
    
    let newBindings = self.bindings.map { binding -> PatternBindingSyntax in      
      if let initializer = binding.initializer {
        let newInitializer = modifier(initializer)
        return binding.with(\.initializer, newInitializer)
      }
      return binding
    }
    
    return self.with(\.bindings, .init(newBindings))
  }
  
}
