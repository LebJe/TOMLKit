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

public extension TOMLValue {
	internal init(tomlValuePointer: OpaquePointer) {
		self.tomlValuePointer = tomlValuePointer
	}

	init(booleanLiteral value: Bool) {
		self.tomlValuePointer = nodeFromBool(value)
	}

	init<I: FixedWidthInteger>(_ value: I) {
		self.tomlValuePointer = nodeFromInt(Int64(value))
	}

	init(integerLiteral value: Int) {
		self.tomlValuePointer = nodeFromInt(Int64(value))
	}

	init(_ value: TOMLInt) {
		self.tomlValuePointer = nodeFromInt(Int64(value.value))
		self.tomlInt = value
	}

	init(floatLiteral value: Double) {
		self.tomlValuePointer = nodeFromDouble(value)
	}

	init(stringLiteral value: String) {
		self.tomlValuePointer = nodeFromString(value)
	}

	init(_ value: TOMLDate) {
		self.tomlValuePointer = nodeFromDate(value.cTOMLDate)
	}

	init(_ value: TOMLTime) {
		self.tomlValuePointer = nodeFromTime(value.cTOMLTime)
	}

	init(_ value: TOMLDateTime) {
		self.tomlValuePointer = nodeFromDateTime(value.cTOMLDateTime)
	}

	init(_ value: TOMLTable) {
		self.tomlValuePointer = nodeFromTable(value.tablePointer)
	}

	init(dictionaryLiteral elements: (String, TOMLValue)...) {
		self.tomlValuePointer = TOMLTable(Dictionary(uniqueKeysWithValues: elements)).tablePointer
	}

	init(_ value: TOMLArray) {
		self.tomlValuePointer = nodeFromArray(value.arrayPointer)
	}

	init(arrayLiteral elements: TOMLValue...) {
		self.tomlValuePointer = TOMLArray(elements).arrayPointer
	}
}
