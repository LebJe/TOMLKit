// Copyright (c) 2021 Jeff Lebrun
//
//  Licensed under the MIT License.
//
//  The full text of the license can be found in the file named LICENSE.

import CTOML

/// A value in a TOML document.
public struct TOMLValue: CustomDebugStringConvertible {
	/// The pointer to the underlying `toml::node`.
	private let tomlValuePointer: OpaquePointer

	public var type: TOMLType {
		nodeType(self.tomlValuePointer).tomlType
	}

	public var debugDescription: String {
		switch self.type {
			case .table: return self.table?.debugDescription ?? ""
			case .array: /* return self.array?.debugDescription ?? */ return ""
			case .string: return self.string ?? ""
			case .int: return self.int != nil ? String(self.int!) : ""
			case .double: return self.double != nil ? String(self.double!) : ""
			case .bool: return self.bool != nil ? String(self.bool!) : ""
			case .date: return self.date?.debugDescription ?? ""
			case .time: return self.time?.debugDescription ?? ""
			case .dateTime: return self.dateTime?.debugDescription ?? ""
		}
	}

	internal init(tomlValuePointer: OpaquePointer) {
		self.tomlValuePointer = tomlValuePointer
	}

	internal var tomlValue: TOMLValue {
		TOMLValue(tomlValuePointer: self.tomlValuePointer)
	}

	/// Converts this `TOMLValue` to a `Bool`. If the conversion fails, this will return `nil`.
	public var bool: Bool? {
		guard let pointer = nodeAsBool(self.tomlValuePointer) else { return nil }
		return pointer.pointee
	}

	/// Converts this `TOMLValue` to an `Int`. If the conversion fails, this will return `nil`.
	public var int: Int? {
		guard let pointer = nodeAsInt(self.tomlValuePointer) else { return nil }
		return Int(pointer.pointee)
	}

	/// Converts this `TOMLValue` to a `Double`. If the conversion fails, this will return `nil`.
	public var double: Double? {
		guard let pointer = nodeAsDouble(self.tomlValuePointer) else { return nil }
		return pointer.pointee
	}

	/// Converts this `TOMLValue` to a `String`. If the conversion fails, this will return `nil`.
	public var string: String? {
		guard let pointer = nodeAsString(self.tomlValuePointer) else { return nil }
		return String(cString: pointer)
	}

	/// Converts this `TOMLValue` to a `TOMLDate`. If the conversion fails, this will return `nil`.
	public var date: TOMLDate? {
		guard let pointer = nodeAsDate(self.tomlValuePointer) else { return nil }
		return TOMLDate(cTOMLDate: pointer.pointee)
	}

	/// Converts this `TOMLValue` to a `TOMLTime`. If the conversion fails, this will return `nil`.
	public var time: TOMLTime? {
		guard let pointer = nodeAsTime(self.tomlValuePointer) else { return nil }
		return TOMLTime(cTOMLTime: pointer.pointee)
	}

	/// Converts this `TOMLValue` to a `TOMLDateTime`. If the conversion fails, this will return `nil`.
	public var dateTime: TOMLDateTime? {
		guard let pointer = nodeAsDateTime(self.tomlValuePointer) else { return nil }
		return TOMLDateTime(cTOMLDateTime: pointer.pointee)
	}

	/// Converts this `TOMLValue` to a `TOMLTable`. If the conversion fails, this will return `nil`.
	public var table: TOMLTable? {
		guard let pointer = nodeAsTable(self.tomlValuePointer) else { return nil }
		return TOMLTable(tablePointer: pointer)
	}

	/// Converts this `TOMLValue` to a `TOMLArray`. If the conversion fails, this will return `nil`.
	public var array: TOMLArray? {
		guard let pointer = nodeAsArray(self.tomlValuePointer) else { return nil }
		return TOMLArray(arrayPointer: pointer)
	}

	/// Cast `self` to a `TOMLTable` and return the value at `key`.
	///
	/// This subscript **WILL crash** if `self` does not represent a `TOMLTable`! **USE AT YOUR OWN RISK!**
	public subscript(key: String) -> TOMLValue { self.table![key]! }

	/// Cast `self` to a `TOMLArray` and return the value at `index`.
	///
	/// This subscript **WILL crash** if `self` does not represent a `TOMLArray`! **USE AT YOUR OWN RISK!**
	public subscript(index: Int) -> TOMLValue { self.array![index]! }
}
