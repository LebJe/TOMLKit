// Copyright (c) 2021 Jeff Lebrun
//
//  Licensed under the MIT License.
//
//  The full text of the license can be found in the file named LICENSE.

import CTOML

/// An array in a TOML document.
public class TOMLArray:
	Equatable,
	Sequence,
	ExpressibleByArrayLiteral,
	CustomDebugStringConvertible,
	TOMLValueConvertible
{
	public var type: TOMLType { .array }

	public var startIndex: Int { 0 }

	public var endIndex: Int { self.count }

	public var tomlValue: TOMLValue { get { .init(self) } set {} }

	/// The amount of elements in the array.
	public var count: Int { arraySize(self.arrayPointer) }

	/// If this array is empty.
	public var isEmpty: Bool { arrayIsEmpty(self.arrayPointer) }

	public var debugDescription: String {
		"[\(self.map({ "\($0.debugDescription)" }).joined(separator: ", "))]"
	}

	/// A pointer to the underlying `toml::array`.
	let arrayPointer: OpaquePointer

	init(arrayPointer: OpaquePointer) {
		self.arrayPointer = arrayPointer
	}

	/// Create a new `TOMLArray`.
	public required init() {
		self.arrayPointer = arrayCreate()
	}

	/// Creates a new `TOMLArray` using the contents of a Swift array.
	public init(_ array: [TOMLValueConvertible]) {
		self.arrayPointer = arrayCreate()
		var index = 0

		array.forEach({
			$0.tomlValue.insertIntoArray(arrayPointer: self.arrayPointer, index: index)
			index += 1
		})
	}

	public required init(arrayLiteral: TOMLValueConvertible...) {
		self.arrayPointer = arrayCreate()
		var index = 0

		arrayLiteral.forEach({
			$0.tomlValue.insertIntoArray(arrayPointer: self.arrayPointer, index: index)
			index += 1
		})
	}

	/// Remove all the elements from this array.
	public func clear() {
		arrayClear(self.arrayPointer)
	}

	func insertIntoTable(tablePointer: OpaquePointer, key: String) {
		tableInsertArray(tablePointer, strdup(key), self.arrayPointer)
	}

	func insertIntoArray(arrayPointer: OpaquePointer, index: Int) {
		arrayInsertArray(arrayPointer, Int64(index), self.arrayPointer)
	}

	public static func == (lhs: TOMLArray, rhs: TOMLArray) -> Bool {
		arrayEqual(lhs.arrayPointer, rhs.arrayPointer)
	}

	public func makeIterator() -> TOMLArrayIterator {
		TOMLArrayIterator(array: self)
	}
}
