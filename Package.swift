// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "abjc-core",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "abjc-core",
            targets: ["abjc-core"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ABJC/JellyKit", from: "1.0.0-build.7")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "abjc-core",
            dependencies: ["JellyKit"]),
        .testTarget(
            name: "abjc-coreTests",
            dependencies: ["abjc-core"]),
    ]
)
