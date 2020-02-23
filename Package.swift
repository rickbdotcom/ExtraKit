// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ExtraKit",
    platforms: [
		.iOS(.v10)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "ExtraKitCore",
            targets: ["ExtraKitCore"]
		),
		.library(
			name: "ExtraKitUI",
			targets: ["ExtraKitUI"]
		)
    ],
    dependencies: [
        .package(url: "https://github.com/mxcl/PromiseKit", from: "6.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "ExtraKitCore",
            dependencies: []
		),
        .target(
            name: "ExtraKitUI",
            dependencies: ["ExtraKitCore"]
		),
        .testTarget(
            name: "ExtraKitCoreTests",
            dependencies: ["ExtraKitCore"]
		),
		.testTarget(
			name: "ExtraKitUITests",
			dependencies: ["ExtraKitUI"]
		)
    ]
)
