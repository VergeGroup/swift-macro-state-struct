import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacros

public struct COWTrackingPropertyMacro {
  
  public enum Error: Swift.Error {
    case needsTypeAnnotation
  }
  
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
        
    guard variableDecl.typeSyntax != nil else {
      context.addDiagnostics(from: Error.needsTypeAnnotation, node: declaration)
      return []
    }

    let isPublic = variableDecl.modifiers.contains(where: { $0.name.tokenKind == .keyword(.public) })
    let isPrivate = variableDecl.modifiers.contains(where: { $0.name.tokenKind == .keyword(.private) })
    
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

    if variableDecl.isOptional {
      _variableDecl =
        _variableDecl
        .renamingIdentifier(with: "_backing_")
        .modifyingTypeAnnotation({ type in
          return "_BackingStorage<\(type.trimmed)>"
        })

      // add init
      _variableDecl = _variableDecl.with(
        \.bindings,
        .init(
          _variableDecl.bindings.map { binding in
            binding.with(\.initializer, .init(value: "_BackingStorage.init(nil)" as ExprSyntax))
          })
      )

    } else {
      _variableDecl =
        _variableDecl
        .renamingIdentifier(with: "_backing_")
        .modifyingTypeAnnotation({ type in
          return "_BackingStorage<\(type.trimmed)>"
        })
        .modifyingInit({ initializer in
          return .init(value: "_BackingStorage.init(\(initializer.trimmed.value))" as ExprSyntax)
        })
    }
    
    do {
      
      // remove accessors
      _variableDecl = _variableDecl.with(
        \.bindings,
         .init(
          _variableDecl.bindings.map { binding in
            binding.with(\.accessorBlock, nil)
          }
         )           
      )
                                  
    }

    newMembers.append(DeclSyntax(_variableDecl))
    
    var accessor: String
    if isPrivate {
      accessor = "private"
    } else if isPublic {
      accessor = "public"
    } else {
      accessor = "internal"
    }
    
    do {
      let referencingAccessor = """
      \(raw: accessor) var $\(raw: variableDecl.name): Referencing<\(variableDecl.typeSyntax!.trimmed)> {
        Referencing(storage: _backing_\(raw: variableDecl.name))
      }
      """ as DeclSyntax
      
      newMembers.append(referencingAccessor)
    }

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
    let typeName = variableDecl.typeSyntax!.trimmed
    let backingName = "_backing_" + propertyName
    let hasWillSet = variableDecl.willSetBlock != nil

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
      get {
      
        let component = PropertyPath.Component.init("\(raw: propertyName)")
        _tracking_context.trackingResultRef?.accessorRead(path: _tracking_context.path?.pushed(component))

        if var value = \(raw: backingName).value as? TrackingObject, let ref = _tracking_context.trackingResultRef {
      	
          if value._tracking_context.trackingResultRef !== ref {
            value._tracking_context = _TrackingContext(trackingResultRef: ref)
          }      
      
          value._tracking_context.path = _tracking_context.path?.pushed(component)
      
          return value as! \(typeName)
        }
      
        return \(raw: backingName).value        
      }
      """
    )

    let setAccessor = AccessorDeclSyntax(
      """
      set { 
        
        // willset
        \(variableDecl.makeWillSetDoBlock())
      
        if let ref = _tracking_context.trackingResultRef {      
          ref.accessorSet(path: _tracking_context.path?.pushed(.init("\(raw: propertyName)")))      
        }
      
        if !isKnownUniquelyReferenced(&\(raw: backingName)) {
          \(raw: backingName) = .init(newValue)
        } else {
          \(raw: backingName).value = newValue             
        }

        // didSet 
        \(variableDecl.makeDidSetDoBlock())
      }
      """
    )

    let modifyAccessor = AccessorDeclSyntax(
      """
      _modify {
      
        if let ref = _tracking_context.trackingResultRef {      
          ref.accessorModify(path: _tracking_context.path?.pushed(.init("\(raw: propertyName)")))      
        }
      
        if !isKnownUniquelyReferenced(&\(raw: backingName)) {  
          \(raw: backingName) = .init(\(raw: backingName).value)
        }
      
        let oldValue = \(raw: backingName).value
      
        if var value = \(raw: backingName).value as? TrackingObject,
           let ref = _tracking_context.trackingResultRef {
        
          let component = PropertyPath.Component.init("\(raw: propertyName)")
                      
          if value._tracking_context.trackingResultRef !== ref {
            value._tracking_context = _TrackingContext(trackingResultRef: ref)
          }  
          value._tracking_context.path = _tracking_context.path?.pushed(component)

          \(raw: backingName).value = value as! \(typeName)
                        
          yield &\(raw: backingName).value
        } else {            
          yield &\(raw: backingName).value
        }
            
        // didSet   
        \(variableDecl.makeDidSetDoBlock())
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

extension VariableDeclSyntax {
  
  var name: String {
    return self.bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text ?? ""
  }
  
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

  var isOptional: Bool {

    return self.bindings.contains(where: {
      $0.typeAnnotation?.type.is(OptionalTypeSyntax.self) ?? false
    })

  }
  
  var typeSyntax: TypeSyntax? {
    return self.bindings.first?.typeAnnotation?.type    
  }

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

  func modifyingInit(_ modifier: (InitializerClauseSyntax) -> InitializerClauseSyntax)
    -> VariableDeclSyntax
  {

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

extension VariableDeclSyntax {
  
  func makeDidSetDoBlock() -> DoStmtSyntax {
    guard let didSetBlock = self.didSetBlock else {
      return .init(body: "{}")
    }
    
    return .init(body: didSetBlock)    
  }
  
  func makeWillSetDoBlock() -> DoStmtSyntax {
    guard let willSetBlock = self.willSetBlock else {
      return .init(body: "{}")
    }
    
    return .init(body: willSetBlock)    
  }
  
  var didSetBlock: CodeBlockSyntax? {
    for binding in self.bindings {
      if let accessorBlock = binding.accessorBlock {
        switch accessorBlock.accessors {
        case .accessors(let accessors):
          for accessor in accessors {
            if accessor.accessorSpecifier.tokenKind == .keyword(.didSet) {
              return accessor.body
            }
          }
        case .getter:
          return nil
        }       
      }
    }
    return nil
  }
  
  var willSetBlock: CodeBlockSyntax? {
    for binding in self.bindings {
      if let accessorBlock = binding.accessorBlock {
        switch accessorBlock.accessors {
        case .accessors(let accessors):
          for accessor in accessors {
            if accessor.accessorSpecifier.tokenKind == .keyword(.willSet) {
              return accessor.body
            }
          }
        case .getter:
          return nil
        }       
      }
    }
    return nil
  }
}
