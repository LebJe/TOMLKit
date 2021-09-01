# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
