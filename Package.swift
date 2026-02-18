// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "EDFViewerMacOS",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "EDFViewerMacOS", targets: ["EDFViewerMacOS"])
    ],
    targets: [
        .executableTarget(
            name: "EDFViewerMacOS",
            path: "Sources/EDFViewerMacOS"
        )
    ]
)
