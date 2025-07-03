// Copyright (c) 2024 Jeff Lebrun
//
//  Licensed under the MIT License.
//
//  The full text of the license can be found in the file named LICENSE.

#if canImport(Darwin)
	import Darwin.C
#elseif canImport(Glibc)
    import Glibc
#elseif canImport(Musl)
    import Musl
#elseif canImport(ucrt)
	import ucrt
#else
	#error("Unsupported Platform")
#endif

import CTOML
import struct Foundation.Data

/// A type that can be converted into a value in a TOML document.
///
/// You should not conform your types to this protocol. Instead, interact with this protocol through the types that
/// conform to it:
///
/// ```swift
/// myTOMLTable["string"]! // <- subscript returns `TOMLValueConvertible`
/// myTOMLArray[0] // <- subscript returns `TOMLValueConvertible`
///
/// myTOMLTable["int"] = 1 // as TOMLValueConvertible
/// myTOMLArray.append(true /* as TOMLValueConvertible */)
/// ```
///
/// The properties in this protocol are used to determine the TOML type of a ``TOMLValueConvertible`` conformant type,
/// or to convert a generic ``TOMLValueConvertible`` to a concrete type:
///
/// ```swift
///	let array: TOMLArray? = myTOMLArray[0].array
///	let int: Int? = myTOMLTable["int"]?.int
///	let table: TOMLTable? = myTOMLArray[0]?[6]?["table"]?.table // `TOMLValueConvertible` provides subscripts for
/// nesting
///
///	switch myTOMLTable["table"]?.type {
///		...
///	}
/// ```
///
public protocol TOMLValueConvertible: CustomDebugStringConvertible {
	/// What kind of TOML value this is.
	var type: TOMLType { get }

	/// The `TOMLValue` for this value, used for inserting this value into a `TOMLArray` or a `TOMLTable`.
	var tomlValue: TOMLValue { get set }
}

public extension TOMLValueConvertible {
	/// Converts this `TOMLValueConvertible` to a `Bool`. If the conversion fails, this will return `nil`.
	var bool: Bool? {
		guard
			self.tomlValue.type == .bool,
			let pointer = nodeAsBool(self.tomlValue.tomlValuePointer)
		else { return nil }

		return pointer.pointee
	}

	/// Converts this `TOMLValueConvertible` to an `Int`. If the conversion fails, this will return `nil`.
	var int: Int? {
		guard
			self.tomlValue.type == .int,
			let pointer = nodeAsInt(self.tomlValue.tomlValuePointer)
		else { return nil }

		return Int(pointer.pointee)
	}

	/// Converts this `TOMLValueConvertible` to a `Double`. If the conversion fails, this will return `nil`.
	var double: Double? {
		guard
			self.tomlValue.type == .double,
			let pointer = nodeAsDouble(self.tomlValue.tomlValuePointer)
		else { return nil }

		return pointer.pointee
	}

	/// Converts this `TOMLValueConvertible` to a `String`. If the conversion fails, this will return `nil`.
	var string: String? {
		guard
			self.tomlValue.type == .string,
			let pointer = nodeAsString(self.tomlValue.tomlValuePointer)
		else { return nil }

		return String(cString: pointer)
	}

	/// Converts this `TOMLValueConvertible` to a `TOMLDate`. If the conversion fails, this will return `nil`.
	var date: TOMLDate? {
		guard
			self.tomlValue.type == .date,
			let pointer = nodeAsDate(self.tomlValue.tomlValuePointer)
		else { return nil }

		return TOMLDate(cTOMLDate: pointer.pointee)
	}

	/// Converts this `TOMLValueConvertible` to a `TOMLTime`. If the conversion fails, this will return `nil`.
	var time: TOMLTime? {
		guard
			self.tomlValue.type == .time,
			let pointer = nodeAsTime(self.tomlValue.tomlValuePointer)
		else { return nil }

		return TOMLTime(cTOMLTime: pointer.pointee)
	}

	/// Converts this `TOMLValueConvertible` to a `TOMLDateTime`. If the conversion fails, this will return `nil`.
	var dateTime: TOMLDateTime? {
		guard
			self.tomlValue.type == .dateTime,
			let pointer = nodeAsDateTime(self.tomlValue.tomlValuePointer)
		else { return nil }

		return TOMLDateTime(cTOMLDateTime: pointer.pointee)
	}

	/// Converts this `TOMLValueConvertible` to a `TOMLTable`. If the conversion fails, this will return `nil`.
	var table: TOMLTable? {
		guard
			self.tomlValue.type == .table,
			let pointer = nodeAsTable(self.tomlValue.tomlValuePointer)
		else { return nil }

		return TOMLTable(tablePointer: pointer)
	}

	/// Converts this `TOMLValueConvertible` to a `TOMLArray`. If the conversion fails, this will return `nil`.
	var array: TOMLArray? {
		guard
			self.tomlValue.type == .array,
			let pointer = nodeAsArray(self.tomlValue.tomlValuePointer)
		else { return nil }

		return TOMLArray(arrayPointer: pointer)
	}

	/// Converts this `TOMLValueConvertible` to a `TOMLArray`, then returns the `TOMLValue` at `index`, If the conversion
	/// fails, this will return `nil`.
	subscript(index: Int) -> TOMLValue? {
		get {
			guard self.type == .array else { return nil }
			return self.array?[index].tomlValue
		}
		set {
			guard self.type == .array, let n = newValue else { return }
			self.array?[index] = n
		}
	}

	/// Converts this `TOMLValueConvertible` to a `TOMLTable`, then returns the `TOMLValue` at `key`, If the conversion
	/// fails, this will return `nil`.
	subscript(key: String) -> TOMLValue? {
		get {
			guard self.type == .table else { return nil }
			return self.table?[key]?.tomlValue
		}
		set {
			guard self.type == .table else { return }
			self.table?[key] = newValue
		}
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

extension Dictionary: TOMLValueConvertible where Self.Value: TOMLValueConvertible, Self.Key == String {
	public var type: TOMLType { .table }
	public var tomlValue: TOMLValue { get { .init(.init(self)) } set {} }
}

extension Array: TOMLValueConvertible where Self.Element: TOMLValueConvertible {
	public var type: TOMLType { .array }
	public var tomlValue: TOMLValue { get { .init(.init(self)) } set {} }
}

extension Data: TOMLValueConvertible {
	public var debugDescription: String { self.description }
	public var type: TOMLType { .string }
	public var tomlValue: TOMLValue { get { .init(stringLiteral: self.base64EncodedString()) } set {} }
}
