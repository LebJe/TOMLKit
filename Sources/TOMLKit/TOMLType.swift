// Copyright (c) 2021 Jeff Lebrun
//
//  Licensed under the MIT License.
//
//  The full text of the license can be found in the file named LICENSE.

import CTOML

///
public enum TOMLType: String, CaseIterable {
	/// A TOML table (inlined or not inlined).
	case table

	/// A TOML array.
	case array

	/// A TOML string.
	case string

	/// A TOML integer.
	case int

	/// A TOML floating-point (double) value.
	case double

	/// A TOML boolean.
	case bool

	/// A TOML date.
	case date

	/// A TOML time.
	case time

	/// A TOML date with time.
	case dateTime

	init(cTOMLNodeType: CTOMLNodeType) {
		self = cTOMLNodeType.tomlType
	}
}

extension CTOMLNodeType {
	var tomlType: TOMLType {
		switch self {
			case CTOMLNodeType.array:
				return .array
			case CTOMLNodeType.boolean:
				return .bool
			case CTOMLNodeType.date:
				return .date
			case CTOMLNodeType.dateTime:
				return .dateTime
			case CTOMLNodeType.floatingPoint:
				return .double
			case CTOMLNodeType.integer:
				return .int
			case CTOMLNodeType.string:
				return .string
			case CTOMLNodeType.table:
				return .table
			case CTOMLNodeType.timeType:
				return .time
		}
	}
}
