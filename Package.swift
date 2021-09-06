// swift-tools-version:5.4

import PackageDescription

let package = Package(
	name: "TOMLKit",
	platforms: [
		.macOS(.v10_15),
		.iOS(.v14),
		.watchOS(.v6),
		.tvOS(.v12),
	],
	products: [
		.library(name: "TOMLKit", targets: ["TOMLKit"]),
	],
	dependencies: [
		// Use this dependency when one of the `TOMLTable` comparison tests fail and
		// XCTAssertEqual tells you "<huge TOMLTable> is not equal to <other huge TOMLTable>"
		// .package(url: "https://github.com/pointfreeco/swift-custom-dump", from: "0.1.0")
	],
	targets: [
		.target(
			name: "CTOML",
			cxxSettings: [
				.define("TOML_LARGE_FILES", to: "1"),
				.define("TOML_EXCEPTIONS", to: "1"),
			]
		),
		.target(
			name: "TOMLKit",
			dependencies: ["CTOML"]
		),
		.testTarget(
			name: "TOMLKitTests",
			dependencies: ["TOMLKit" /* .product(name: "CustomDump", package: "swift-custom-dump") */ ]
		),
	],
	cLanguageStandard: .c99,
	cxxLanguageStandard: .cxx17
)
