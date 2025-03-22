import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct Plugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    TrackingMacro.self,
    COWTrackingPropertyMacro.self,
    PrimitiveTrackingPropertyMacro.self,
    TrackingIgnoredMacro.self,
  ]
}
