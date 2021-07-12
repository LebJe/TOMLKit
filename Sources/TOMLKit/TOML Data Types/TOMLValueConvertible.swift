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

public protocol TOMLValueConvertible: CustomDebugStringConvertible {
	/// What kind of TOML value this is.
	var type: TOMLType { get }

	/// The `TOMLValue` for this value, used for inserting this value into a `TOMLArray` or a `TOMLTable`.
	var tomlValue: TOMLValue { get set }
}

extension TOMLValueConvertible {
	/// Converts this `TOMLValue` to a `Bool`. If the conversion fails, this will return `nil`.
	var bool: Bool? {
		guard let pointer = nodeAsBool(self.tomlValue.tomlValuePointer) else { return nil }
		return pointer.pointee
	}

	/// Converts this `TOMLValue` to an `Int`. If the conversion fails, this will return `nil`.
	var int: Int? {
		guard let pointer = nodeAsInt(self.tomlValue.tomlValuePointer) else { return nil }
		return Int(pointer.pointee)
	}

	/// Converts this `TOMLValue` to a `Double`. If the conversion fails, this will return `nil`.
	var double: Double? {
		guard let pointer = nodeAsDouble(self.tomlValue.tomlValuePointer) else { return nil }
		return pointer.pointee
	}

	/// Converts this `TOMLValue` to a `String`. If the conversion fails, this will return `nil`.
	var string: String? {
		guard let pointer = nodeAsString(self.tomlValue.tomlValuePointer) else { return nil }
		return String(cString: pointer)
	}

	/// Converts this `TOMLValue` to a `TOMLDate`. If the conversion fails, this will return `nil`.
	var date: TOMLDate? {
		guard let pointer = nodeAsDate(self.tomlValue.tomlValuePointer) else { return nil }
		return TOMLDate(cTOMLDate: pointer.pointee)
	}

	/// Converts this `TOMLValue` to a `TOMLTime`. If the conversion fails, this will return `nil`.
	var time: TOMLTime? {
		guard let pointer = nodeAsTime(self.tomlValue.tomlValuePointer) else { return nil }
		return TOMLTime(cTOMLTime: pointer.pointee)
	}

	/// Converts this `TOMLValue` to a `TOMLDateTime`. If the conversion fails, this will return `nil`.
	var dateTime: TOMLDateTime? {
		guard let pointer = nodeAsDateTime(self.tomlValue.tomlValuePointer) else { return nil }
		return TOMLDateTime(cTOMLDateTime: pointer.pointee)
	}

	/// Converts this `TOMLValue` to a `TOMLTable`. If the conversion fails, this will return `nil`.
	var table: TOMLTable? {
		guard let pointer = nodeAsTable(self.tomlValue.tomlValuePointer) else { return nil }
		return TOMLTable(tablePointer: pointer)
	}

	/// Converts this `TOMLValue` to a `TOMLArray`. If the conversion fails, this will return `nil`.
	var array: TOMLArray? {
		get {
			guard let pointer = nodeAsArray(self.tomlValue.tomlValuePointer) else { return nil }
			return TOMLArray(arrayPointer: pointer)
		}
		// This allows manipulating values through subscripts.
		set {}
	}
}

extension Bool: TOMLValueConvertible {
	public var debugDescription: String { self.description }

	public var type: TOMLType { .bool }

	public var tomlValue: TOMLValue { get { .init(booleanLiteral: self) } set {} }
}

extension Double: TOMLValueConvertible {
	public var type: TOMLType { .double }

	public var tomlValue: TOMLValue { get { .init(floatLiteral: self) } set {} }
}

extension String: TOMLValueConvertible {
	public var type: TOMLType { .string }
	public var debugDescription: String { self }
	public var tomlValue: TOMLValue { get { .init(stringLiteral: self) } set {} }
}

extension Int: TOMLValueConvertible {
	public var debugDescription: String { self.description }

	public var type: TOMLType { .string }
	public var tomlValue: TOMLValue { get { .init(self) } set {} }
}
