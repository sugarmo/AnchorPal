// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AnchorKit",
    platforms: [
        .iOS(.v9),
        .tvOS(.v9),
        .macOS(.v10_11),
    ],
    products: [
        .library(
            name: "AnchorKit",
            targets: ["AnchorKit"]),
    ], targets: [
        .target(
            name: "AnchorKit",
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "AnchorKitTests",
            dependencies: ["AnchorKit"],
            path: "Tests"),
    ], swiftLanguageVersions: [
        .v5,
    ]
)
