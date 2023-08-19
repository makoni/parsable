// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Parsable",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Parsable",
            targets: ["Parsable"]
		)
    ],
	dependencies: [
		.package(url: "https://github.com/apple/swift-docc-plugin", from: "1.3.0")
	],
    targets: [
        .target(name: "Parsable"),
        .testTarget(name: "ParsableTests", dependencies: ["Parsable"])
    ]
)
