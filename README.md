# TOMLKit

**A small, simple TOML parser and serializer for Swift. Powered by [toml++](https://github.com/marzer/tomlplusplus/).**

[![Swift 5.4](https://img.shields.io/badge/Swift-5.4-brightgreen?logo=swift)](https://swift.org)
[![SPM Compatible](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager)
[![](https://img.shields.io/github/v/tag/LebJe/TOMLKit)](https://github.com/LebJe/TOMLKit/releases)
[![Build and Test](https://github.com/LebJe/TOMLKit/workflows/Build%20and%20Test/badge.svg)](https://github.com/LebJe/TOMLKit/actions?query=workflow%3A%22Build+and+Test%22)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FLebJe%2FTOMLKit%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/LebJe/TOMLKit)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FLebJe%2FTOMLKit%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/LebJe/TOMLKit)

TOMLKit is a [Swift](https://swift.org) wrapper around [toml++](https://github.com/marzer/tomlplusplus/), allowing you to parse and serialize [TOML](https://toml.io) files in Swift.

## Table of Contents

<!--ts-->

-   [TOMLKit](#tomlkit)
    -   [Table of Contents](#table-of-contents)
    -   [Installation](#installation)
        -   [Swift Package Manager](#swift-package-manager)
    -   [Quick Start](#quick-start)
        -   [Full Documentation](#full-documentation)
    -   [Dependencies](#dependencies)
    -   [Licenses](#licenses)
    -   [Contributing](#contributing)

<!-- Added by: lebje, at: Tue Jan 18 10:50:45 EST 2022 -->

<!--te-->

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)

Documentation is available [here](https://lebje.github.io/TOMLKit/documentation/tomlkit).

## Installation

### Swift Package Manager

Add this to the `dependencies` array in `Package.swift`:

```swift
.package(url: "https://github.com/LebJe/TOMLKit.git", from: "0.4.0")
```

Also add this to the `targets` array in the aforementioned file:

```swift
.product(name: "TOMLKit", package: "TOMLKit")
```

## Quick Start

```swift
import TOMLKit
import struct Foundation.Date

let toml = """
string = "Hello, World!"
int = 523053
double = 3250.34
"""

do {
   let table = try TOMLTable(string: toml)
   table.remove(at: "double")

   table["dateTime"] = TOMLDateTime(date: Foundation.Date())
   table.insert(
      TOMLArray([1, 2, "3", TOMLTable(["time": TOMLTime(hour: 10, minute: 26, second: 49, nanoSecond: 203)])]),
      at: "array"
   )

   print("TOML:\n\(table.convert(to: .toml))\n")
   print("JSON:\n\(table.convert(to: .json))\n")
   print("YAML:\n\(table.convert(to: .yaml))")
} catch let error as TOMLParseError {
   // TOMLParseError occurs when the TOML document is invalid.
   // `error.source.begin` contains the line and column where the error started,
   // and `error.source.end` contains the line where the error ended.
    print(error.source.begin)
    print(error.source.end)
}

// TOML:
// array = [ 1, 2, '3', { time = 10:26:49.000000203 } ]
// dateTime = 2022-01-18T10:47:49.640691995Z
// int = 523053
// string = 'Hello, World!'
//
// JSON:
// {
//     "array" : [
//         1,
//         2,
//         "3",
//         {
//             "time" : "10:26:49.000000203"
//         }
//     ],
//     "dateTime" : "2022-01-18T10:47:49.640691995Z",
//     "int" : 523053,
//     "string" : "Hello, World!"
// }
//
// YAML:
// array:
//   - 1
//   - 2
//   - 3
//   - time: '10:26:49.000000203'
// dateTime: '2022-01-18T10:47:49.640691995Z'
// int: 523053
// string: 'Hello, World!'
```

### Full Documentation

Full documentation is available [here](https://lebje.github.io/TOMLKit/documentation/tomlkit/).

## Dependencies

-   [toml++](https://github.com/marzer/tomlplusplus/)

## Licenses

The [toml++](https://github.com/marzer/tomlplusplus/) license is available in the `tomlplusplus` directory in the `LICENSE` file.

## Contributing

Before committing, please install [pre-commit](https://pre-commit.com), [swift-format](https://github.com/nicklockwood/SwiftFormat), [clang-format](https://clang.llvm.org/docs/ClangFormat.html), and [Prettier](https://prettier.io), then install the pre-commit hook:

```bash
$ brew bundle # install the packages specified in Brewfile
$ pre-commit install

# Commit your changes.
```

To install pre-commit on other platforms, refer to the [documentation](https://pre-commit.com/#install).
