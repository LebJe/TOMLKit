// Copyright (c) 2021 Jeff Lebrun
//
//  Licensed under the MIT License.
//
//  The full text of the license can be found in the file named LICENSE.

import CTOML

/// An integer in a TOML document.
public struct TOMLInt: ExpressibleByIntegerLiteral, Equatable, TOMLValueConvertible {
	public var type: TOMLType { .int }

	public typealias IntegerLiteralType = Int

	public var value: Int

	public private(set) var options: ValueOptions = .none

	/// Create a new `TOMLInt`.
	/// - Parameters:
	///   - value: the `Int` that will be inserted into the TOML document.
	///   - options: The formatting options for `value`.
	public init<I: FixedWidthInteger>(_ value: I, options: ValueOptions = .none) {
		self.value = Int(value)
		self.options = options
	}

	public init(integerLiteral value: Int) {
		self.value = value
	}

	public static func == (lhs: TOMLInt, rhs: TOMLInt) -> Bool {
		lhs.value == rhs.value
	}

	public func insertIntoTable(tablePointer: OpaquePointer, key: String) {
		tableInsertInt(tablePointer, strdup(key), Int64(self.value), self.options.rawValue)
	}

	public func insertIntoArray(arrayPointer: OpaquePointer, index: Int) {
		arrayInsertInt(arrayPointer, Int64(index), Int64(self.value), self.options.rawValue)
	}
}

public extension FixedWidthInteger {
	var tomlInt: TOMLInt { TOMLInt(self) }
}
