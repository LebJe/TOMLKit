# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.5.1](https://github.com/LebJe/TOMLKit/releases/tag/0.5.1) - 2022-03-31

### Fixed

-   [Fatal crash during decoding](https://github.com/LebJe/TOMLKit/issues/12) (#13 by @stackotter)

-   Fix pre-commit workflows by replacing `git://...` URL with a `https://` one.

## [0.5.0](https://github.com/LebJe/TOMLKit/releases/tag/0.5.0) - 2022-01-18

### Added

-   `TOMLTable` can now be converted to YAML.
-   More `FormatOptions` have been added.
-   Better and more organized documentation.

### Changed

-   Upgraded to [toml++ v3.0.1](https://github.com/marzer/tomlplusplus/releases/tag/v3.0.1).
-   Documentation has been moved out of the README and into the [main documentation page](https://lebje.github.io/TOMLKit/documentation/tomlkit/).
-   The `public` variables in `TOMLDate`, `TOMLTime` and `TOMLDateTime` are now mutable.
-   `TOMLDate.date` and `TOMLDateTime.fDate` now return an `Optional<Foundation.Date>`.

### Removed

-   `FormatOptions.allowValueFormatFlags`.

## [0.4.0](https://github.com/LebJe/TOMLKit/releases/tag/0.4.0) - 2021-12-12

### Added

-   `Array` conforms to `TOMLValueConvertible` when its `Element` conforms to the protocol.
-   `TOMLArray` now conforms to `Encodable`, and can be initialized from a type conforming to `Sequence`.
-   `TOMLTable` conforms to `Encodable`.
-   `(U)Int8|16|32|64` now conforms to `TOMLValueConvertible`.

### Changed

-   The `TOMLDecoder.dataDecoder` closure now accepts a `TOMLValueConvertible` instead of a `String`.
-   The `TOMLDate` initializer that accepts a `Date` as its parameter is now an optional initializer.
-   The `TOMLDateTime` initializer that accepts a `Date` as its parameter is now an optional initializer.

## [0.3.2](https://github.com/LebJe/TOMLKit/releases/tag/0.3.2) - 2021-09-17

### Fixed

-   `TOMLDecoder` can now decode `Dictionary<String, ...>.self`.

## [0.3.1](https://github.com/LebJe/TOMLKit/releases/tag/0.3.1) - 2021-09-16

### Fixed

-   `TOMLParseError` is now `public`.

## [0.3.0](https://github.com/LebJe/TOMLKit/releases/tag/0.3.0) - 2021-09-06

### Added

-   Links to the official documentation from `TOMLInt`, `TOMLTable`, `TOMLArray`, `TOMLDate`, `TOMLTime`, `TOMLDateTime`, and `TOMLTimeOffset`.
-   [toml++](https://github.com/marzer/tomlplusplus/) is now used to format `TOMLArray`, `TOMLDate`, `TOMLTime`, and `TOMLDateTime`, when they are being printed.
-   Improved the formatting of strings in `TOMLValue.debugDescription`.
-   Setting a value in a `TOMLTable` or `TOMLArray` via a nested subscript is now possible.

```swift
tomlTable["InnerTable"]?["Int"] = 1
tomlArray[0]?[0] = "Hello, World!"
```

### Changed

-   Improved the debug output of `TOMLParseError`.

### Fixed

-   It is no longer necessary to add `.tomlValue` after the first subscript in a subscript chain.

```swift
// Before:
tomlTable["InnerTable"]?.tomlValue["InnerTable"]
tomlArray[0]?.tomlValue[0]

// After:
tomlTable["InnerTable"]?["InnerTable"]
tomlArray[0]?[0]
```

## [0.2.0](https://github.com/LebJe/TOMLKit/releases/tag/0.2.0) - 2021-09-01

### Added

-   `TOMLEncoder.dataEncoder` now allows one to encode `Data` into any type that conforms to `TOMLValueConvertible`.

### Fixed

-   `TOMLDecoder` now passes `TOMLDecoder.userInfo` to `InternalTOMLDecoder`'s initializer.
-   Improved code formatting.

## [0.1.2](https://github.com/LebJe/TOMLKit/releases/tag/0.1.2) - 2021-07-27

### Added

-   Support for encoding and decoding `Foundation.Data` in Base64 or a custom format.

## [0.1.1](https://github.com/LebJe/TOMLKit/releases/tag/0.1.1) - 2021-06-22

### Added

-   Add `TOMLArrayIterator` and `TOMLTableIterator`.

### Fixed

-   `TOMLArray.checkIndex(index:)` now checks that `index <= self.endIndex - 1` instead of `index <= self.endIndex`.

## [0.1.0](https://github.com/LebJe/TOMLKit/releases/tag/0.1.0) - 2021-06-17

### Added

-   Add support for tvOS and watchOS.

-   `TOMLArray` conforms to:

    -   `Collection`,
    -   `RandomAccessCollection`,
    -   `BidirectionalCollection`,
    -   `RangeReplaceableCollection`,
    -   `MutableCollection`

-   `TOMLArray`'s and `TOMLTable`'s two subscripts have been merged: only one subscript is used for insert and retrieving values.
-   `structs` conforming to `TOMLValueConvertible` don't insert themselves into a `TOMLArray` or a `TOMLTables` anymore.
    Now they have a `tomlValue` property, which converts them into `TOMLValue`s. The `TOMLValue` then inserts itself into a `TOMLTable` or a `TOMLArray`.
-   `TOMLTable.remove(at:)` now returns a copy of the removed `TOMLValueConvertible`.
-   Added functions to check if a key is in a `TOMLTable`.
-   Tried to improve the code in `Sources/CTOML`.

### Removed

-   Removed the `inline` parameter from `TOMLTable.init(string:)`.

### Fixed

-   Retrieving a value from a `TOMLArray` no longer returns an `Optional` value.

## [0.0.2](https://github.com/LebJe/TOMLKit/releases/tag/0.0.2) - 2021-06-10

### Added

-   Made `TOMLType` conform to `RawRepresentable`.

### Fixed

-   Fixed formatting.
-   `throw` `DecodingError` instead of crashing when decoding.

## [0.0.1](https://github.com/LebJe/TOMLKit/releases/tag/0.0.1) - 2021-06-10

### Added

-   Initial release.
