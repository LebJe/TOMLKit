// Copyright (c) 2021 Jeff Lebrun
//
//  Licensed under the MIT License.
//
//  The full text of the license can be found in the file named LICENSE.

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

	func next() -> (String, TOMLValueConvertible)? {
		if self.currentIndex == 0 {
			self.storedKeys = self.keys
		}

		guard self.currentIndex <= self.count - 1 else {
			self.currentIndex = 0
			self.storedKeys = []
			return nil
		}

		let v = (self.storedKeys[self.currentIndex], self[self.storedKeys[self.currentIndex]]!)
		self.currentIndex += 1

		return v
	}
}
