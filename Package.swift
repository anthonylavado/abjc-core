// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "abjc-core",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v14),
        .tvOS(.v14)
    ],
    products: [
        .library(
            name: "abjc-core",
            targets: ["abjc-core"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ABJC/abjc-api", .upToNextMajor(from: "1.0.0-build.8")),
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
