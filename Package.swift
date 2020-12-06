// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DramatisPersonae",
    products: [
        .executable(name: "DramatisPersonae", targets: ["DramatisPersonae"]),
        .library(name: "StarWarsAPI", targets: ["StarWarsAPI"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime.git", from: "0.2.0"),
        .package(name: "AWSSDKSwift", url: "https://github.com/soto-project/soto.git", from: "4.0.0"),
        .package(url: "https://github.com/GraphQLSwift/Graphiti.git", .upToNextMinor(from: "0.22.0")),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(url: "https://github.com/stephencelis/SQLite.swift.git", from: "0.12.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "DramatisPersonae",
            dependencies: [
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
                .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-runtime"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "SQLite", package: "SQLite.swift"),
                "Graphiti",
                "StarWarsAPI"
            ]),
        .target(
            name: "StarWarsAPI",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                "Graphiti"
            ]),
        .testTarget(
        	name: "DramatisPersonaeTests", 
        	dependencies: ["DramatisPersonae"]),
        .testTarget(
        	name: "StarWarsAPITests", 
        	dependencies: ["StarWarsAPI"])
    ]
)
