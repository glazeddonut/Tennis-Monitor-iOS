// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "TennisMonitorApp",
    platforms: [
        .iOS(.v17)
    ],
    dependencies: [],
    targets: [
        // Models target - contains all data structures
        .target(
            name: "Models",
            dependencies: [],
            path: "Sources/Models"
        ),
        
        // Networking target - depends on Models
        .target(
            name: "Networking",
            dependencies: ["Models"],
            path: "Sources/Networking"
        ),
        
        // Views target - depends on Models and Networking
        .target(
            name: "Views",
            dependencies: ["Models", "Networking"],
            path: "Sources/Views"
        ),
        
        // Main app target - depends on all
        .target(
            name: "TennisMonitorApp",
            dependencies: ["Models", "Networking", "Views"],
            path: "Sources/TennisMonitorApp",
            swiftSettings: [
                .unsafeFlags(["-suppress-warnings"], .when(configuration: .debug))
            ]
        ),
    ]
)
