// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Freee",
    platforms: [
        .macOS(.v14)
    ],
    dependencies: [
        .package(url: "https://github.com/nalexn/ViewInspector.git", from: "0.9.11")
    ],
    targets: [
        .target(
            name: "FreeeLogic",
            path: "Sources/Freee",
            exclude: []
        ),
        .testTarget(
            name: "FreeeTests",
            dependencies: [
                "FreeeLogic",
                "ViewInspector",
            ],
            path: "Tests/FreeeTests"
        ),
    ]
)
