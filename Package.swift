// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let package = Package(
  name: "swift-macro-state-struct",
  platforms: [.macOS(.v13), .iOS(.v16), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
  products: [
    .library(
      name: "StateStruct",
      targets: ["StateStruct"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "602.0.0"),
    .package(url: "https://github.com/pointfreeco/swift-macro-testing.git", from: "0.5.2")
  ],
  targets: [
    .macro(
      name: "StateStructMacros",
      dependencies: [
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
      ]
    ),
    .target(
      name: "StateStruct",
      dependencies: ["StateStructMacros"]
    ),
    .testTarget(
      name: "StateStructMacroTests",
      dependencies: [
        "StateStructMacros",
        .product(name: "MacroTesting", package: "swift-macro-testing"),
        .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
      ]
    ),
    .testTarget(
      name: "StateStructTests",
      dependencies: [
        "StateStruct"
      ]
    ),
  ],
  swiftLanguageModes: [.v6]
)
