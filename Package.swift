// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-iso-11664",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: "ISO 11664", targets: ["ISO 11664"])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-iso/swift-iso-9899.git", branch: "main")
    ],
    targets: [
        .target(
            name: "ISO 11664",
            dependencies: [
                .product(name: "ISO 9899 Core", package: "swift-iso-9899")
            ]
        ),
        .testTarget(
            name: "ISO 11664 Tests",
            dependencies: [
                .target(name: "ISO 11664"),
                .product(name: "ISO 9899 Core", package: "swift-iso-9899"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    target.swiftSettings =
        (target.swiftSettings ?? []) + [
            .strictMemorySafety(),
            .enableUpcomingFeature("ExistentialAny"),
            .enableUpcomingFeature("InternalImportsByDefault"),
            .enableUpcomingFeature("MemberImportVisibility"),
            .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
            .enableUpcomingFeature("InferIsolatedConformances"),
            .enableExperimentalFeature("Lifetimes"),
            .treatAllWarnings(as: .error),
        ]
}
