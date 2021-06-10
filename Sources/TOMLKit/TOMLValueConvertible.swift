// Copyright (c) 2021 Jeff Lebrun
//
//  Licensed under the MIT License.
//
//  The full text of the license can be found in the file named LICENSE.

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
	import Darwin.C
#elseif os(Linux) || os(Android)
	import Glibc
#elseif os(Windows)
	// TODO: is this the right module?
	import ucrt
#else
	#error("Unsupported Platform")
#endif

import CTOML

public protocol TOMLValueConvertible {
	/// What kind of TOML value this is.
	var type: TOMLType { get }

	// func tomlValue() -> TOMLValue

	/// Insert the TOML value into the table referenced by `tablePointer`.
	/// - Parameters:
	///   - tablePointer: The pointer to the `toml::table` that this value will be inserted in.
	///   - key:
	func insertIntoTable(tablePointer: OpaquePointer, key: String)

	/// Insert the TOML value into the array referenced by `arrayPointer`.
	/// - Parameters:
	///   - tablePointer: The pointer to the `toml::array` that this value will be inserted in.
	///   - key:
	func insertIntoArray(arrayPointer: OpaquePointer, index: Int)

	// init(tomlValue: TOMLValue)
}

// extension Array: TOMLValueConvertible where Self.Element: TOMLValueConvertible {
//	var type: TOMLType { .array }
// }

extension String: TOMLValueConvertible {
	public var type: TOMLType { .string }

	public func insertIntoTable(tablePointer: OpaquePointer, key: String) {
		self.withCString({
			tableInsertString(tablePointer, strdup(key), $0)
		})
	}

	public func insertIntoArray(arrayPointer: OpaquePointer, index: Int) {
		self.withCString({
			arrayInsertString(arrayPointer, Int64(index), $0)
		})
	}
}

extension Double: TOMLValueConvertible {
	public var type: TOMLType { .double }

	public func insertIntoTable(tablePointer: OpaquePointer, key: String) {
		tableInsertDouble(tablePointer, strdup(key), self)
	}

	public func insertIntoArray(arrayPointer: OpaquePointer, index: Int) {
		arrayInsertDouble(arrayPointer, Int64(index), self)
	}
}

extension Bool: TOMLValueConvertible {
	public var type: TOMLType { .bool }

	public func insertIntoTable(tablePointer: OpaquePointer, key: String) {
		tableInsertBool(tablePointer, strdup(key), self)
	}

	public func insertIntoArray(arrayPointer: OpaquePointer, index: Int) {
		arrayInsertBool(arrayPointer, Int64(index), self)
	}
}
