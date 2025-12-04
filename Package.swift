// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FactorySim",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "FactorySim", targets: ["FactorySim"])
    ],
    targets: [
        .executableTarget(
            name: "FactorySim",
            path: "FactorySim",
            resources: [
                .copy("Resources/sample_layout.json")
            ]
        ),
        .testTarget(
            name: "FactorySimTests",
            dependencies: ["FactorySim"],
            path: "Tests/FactorySimTests"
        )
    ]
)
