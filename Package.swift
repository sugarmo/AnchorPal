// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AnchorPal",
    platforms: [
        .iOS(.v9),
        .tvOS(.v9),
        .macOS(.v10_11),
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
