import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct TrackingMacro: Macro {

  public enum Error: Swift.Error {
    case needsTypeAnnotation
    case notFoundPropertyName
  }

  public static var formatMode: FormatMode {
    .auto
  }

}

extension TrackingMacro: MemberMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    
    let isPublic = declaration.modifiers.contains(where: { $0.name.tokenKind == .keyword(.public) })
    
    return [
      """
      \(raw: isPublic ? "public" : "internal") var _tracking_context: _TrackingContext = .init()
      """ as DeclSyntax
    ]
  }
}

extension TrackingMacro: ExtensionMacro {
  public static func expansion(
    of node: AttributeSyntax,
    attachedTo declaration: some DeclGroupSyntax,
    providingExtensionsOf type: some TypeSyntaxProtocol,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [ExtensionDeclSyntax] {

    guard let structDecl = declaration.as(StructDeclSyntax.self) else {
      fatalError()
    }
    
    return [
      ("""
      extension \(structDecl.name.trimmed): TrackingObject {      
      }
      """ as DeclSyntax).cast(ExtensionDeclSyntax.self),
    ]
  }
}

extension TrackingMacro: MemberAttributeMacro {

  public static func expansion(
    of node: AttributeSyntax,
    attachedTo declaration: some DeclGroupSyntax,
    providingAttributesFor member: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [AttributeSyntax] {

    guard let variableDecl = member.as(VariableDeclSyntax.self) else {
      return []
    }

    // to ignore computed properties
    for binding in variableDecl.bindings {
      if let accessorBlock = binding.accessorBlock {
        // Check if this is a computed property (has a 'get' accessor)
        // If it has only property observers like didSet/willSet, it's still a stored property
        
        switch accessorBlock.accessors {
        case .accessors(let accessors):
          let hasGetter = accessors.contains { syntax in
            syntax.accessorSpecifier.tokenKind == .keyword(.get)
          }
          if hasGetter {
            return []
          }
          continue
        case .getter:
          return []
        }        
      }
    }
    
    guard variableDecl.bindingSpecifier.tokenKind == .keyword(.var) else {
      return []
    }
    
    let isWeak = variableDecl.modifiers.contains { modifier in
      modifier.name.tokenKind == .keyword(.weak)
    }
    
    if isWeak {
      return [AttributeSyntax(stringLiteral: "@WeakTrackingProperty")]
    } else {
      return [AttributeSyntax(stringLiteral: "@COWTrackingProperty")]
    }
  }

}
