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
    import ucrt
#else
    #error("Unsupported Platform")
#endif

import CTOML

/// An integer in a TOML document.
public struct TOMLInt: ExpressibleByIntegerLiteral, Equatable, TOMLValueConvertible {
	public var type: TOMLType { .int }

	public typealias IntegerLiteralType = Int

	public var value: Int

	public private(set) var options: ValueOptions = .none

	public var tomlValue: TOMLValue { get { .init(self) } set {} }

	public var debugDescription: String {
		switch self.options {
			case .none:
				return String(self.value)
			case .formatAsBinary:
				return "0b" + String(self.value, radix: 2)
			case .formatAsOctal:
				return "0o" + String(self.value, radix: 8)
			case .formatAsHexadecimal:
				return "0x" + String(self.value, radix: 16)
		}
	}

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
}

public extension FixedWidthInteger {
	/// Creates a `TOMLInt` from `self`.
	var tomlInt: TOMLInt { TOMLInt(self) }
}
