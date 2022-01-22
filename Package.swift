// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftGit",
    platforms: [.macOS(.v12), .iOS(.v11)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SwiftGit",
            targets: ["SwiftGit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/linhay/swift-cgit2", .branch("main"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SwiftGit",
            dependencies: [
                .product(name: "Cgit2", package: "swift-cgit2"),
            ]),
        .testTarget(
            name: "SwiftGitTests",
            dependencies: ["SwiftGit"]),
    ]
)
