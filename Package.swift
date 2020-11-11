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
        .package(url: "https://github.com/ABJC/abjc-api", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .target(
            name: "abjc-core",
            dependencies: ["abjc-api"]),
        .testTarget(
            name: "abjc-coreTests",
            dependencies: ["abjc-core"]),
    ]
)
