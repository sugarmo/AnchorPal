// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AnchorPal",
    platforms: [
        .iOS(.v12),
        .tvOS(.v12),
        .macCatalyst(.v13),
        .macOS(.v12),
    ],
    products: [
        .library(
            name: "AnchorPal",
            targets: ["AnchorPal"]),
    ], targets: [
        .target(
            name: "AnchorPal",
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "AnchorPalTests",
            dependencies: ["AnchorPal"],
            path: "Tests"),
    ], swiftLanguageVersions: [
        .v5,
    ]
)
