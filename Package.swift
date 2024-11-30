// swift-tools-version: 6.0
import PackageDescription

let dependencies: [Target.Dependency] = [
  .product(name: "Algorithms", package: "swift-algorithms"),
  .product(name: "Collections", package: "swift-collections"),
  .product(name: "ArgumentParser", package: "swift-argument-parser"),
]

let package = Package(
  name: "AdventOfCode",
  platforms: [.macOS(.v13), .iOS(.v16), .watchOS(.v9), .tvOS(.v16)],
  dependencies: [
    .package(
      url: "https://github.com/apple/swift-algorithms.git",
      .upToNextMajor(from: "1.2.0")),
    .package(
      url: "https://github.com/apple/swift-collections.git",
      .upToNextMajor(from: "1.1.4")),
    .package(
      url: "https://github.com/apple/swift-argument-parser.git",
      .upToNextMajor(from: "1.5.0")),
    .package(
      url: "https://github.com/swiftformat/swift-format.git",
      .upToNextMajor(from: "600.0.0"))
  ],
  targets: [
    .executableTarget(
      name: "AdventOfCode",
      dependencies: dependencies,
      resources: [.copy("Data")]
    ),
    .testTarget(
      name: "AdventOfCodeTests",
      dependencies: ["AdventOfCode"] + dependencies
    )
  ],
  swiftLanguageModes: [.v6]
)
