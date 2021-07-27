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

public extension TOMLTable {
	func contains(key: String) -> Bool {
		tableContains(self.tablePointer, strdup(key))
	}

	func contains(element: TOMLValueConvertible) -> Bool {
		let e = element.tomlValue
		for v in self.values {
			if e == v { return true }
		}

		return false
	}

	func insert(_ value: TOMLValueConvertible, at key: String) {
		value.tomlValue.insertIntoTable(tablePointer: self.tablePointer, key: key)
	}

	/// Remove the element at `key` from this table.
	///
	/// - Returns: `nil` if there was no value at `key`, or the value that was deleted at `key`.
	func remove(at key: String) -> TOMLValueConvertible? {
		if let v = self[key]?.tomlValue.tomlValuePointer {
			let element = TOMLValue(tomlValuePointer: copyNode(v))
			tableRemoveElement(self.tablePointer, strdup(key))
			return element
		} else {
			return nil
		}
	}

	func makeIterator() -> TOMLTableIterator {
		TOMLTableIterator(table: self)
	}
}
