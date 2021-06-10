// Copyright (c) 2021 Jeff Lebrun
//
//  Licensed under the MIT License.
//
//  The full text of the license can be found in the file named LICENSE.

import CTOML

/// An array in a TOML document.
public class TOMLArray: Equatable, ExpressibleByArrayLiteral, CustomDebugStringConvertible, TOMLValueConvertible, IteratorProtocol, Sequence {
	public typealias Element = TOMLValue

	public var type: TOMLType { .array }

	public var startIndex: Int { 0 }

	public var endIndex: Int { self.count - 1 }

	/// The amount of elements in the array.
	public var count: Int {
		arraySize(self.arrayPointer)
	}

	/// If this array is empty.
	public var isEmpty: Bool {
		arrayIsEmpty(self.arrayPointer)
	}

	var tomlValue: TOMLValue {
		TOMLValue(tomlValuePointer: self.arrayPointer)
	}

	public var debugDescription: String {
		"[\n\(self.map({ "\t\($0.debugDescription),\n" }).joined())]"
	}

	/// A pointer to the underlying `toml::array`.
	private let arrayPointer: OpaquePointer

	private var currentIndex = 0

	init(arrayPointer: OpaquePointer) {
		self.arrayPointer = arrayPointer
	}

	/// Create a new `TOMLArray`.
	public init() {
		self.arrayPointer = arrayCreate()
	}

	/// Creates a new `TOMLArray` using the contents of a Swift array.
	public init(_ array: [TOMLValueConvertible]) {
		self.arrayPointer = arrayCreate()
		var index = 0

		array.forEach({
			$0.insertIntoArray(arrayPointer: self.arrayPointer, index: index)
			index += 1
		})
	}

	public required init(arrayLiteral: TOMLValueConvertible...) {
		self.arrayPointer = arrayCreate()
		var index = 0

		arrayLiteral.forEach({
			$0.insertIntoArray(arrayPointer: self.arrayPointer, index: index)
			index += 1
		})
	}

	/// Insert a value into this array.
	public subscript(index: Int) -> TOMLValueConvertible {
		get { fatalError("Use \"public subscript(index: Int) -> TOMLValue\"") }
		set(value) {
			value.insertIntoArray(arrayPointer: self.arrayPointer, index: index)
		}
	}

	/// Retrieve a `TOMLValue` from this array at `index`.
	public subscript(index: Int) -> TOMLValue? {
		guard let pointer = arrayGetNode(self.arrayPointer, Int64(index)) else { return nil }
		return TOMLValue(tomlValuePointer: pointer)
	}

	/// Insert `value` into this array.
	public func append(_ value: TOMLValueConvertible) {
		value.insertIntoArray(arrayPointer: self.arrayPointer, index: self.endIndex + 1)
	}

	/// Insert a `value` into this array at `index`.
	public func insert(_ value: TOMLValueConvertible, at index: Int) {
		value.insertIntoArray(arrayPointer: self.arrayPointer, index: index)
	}

	/// Remove the element at `index` from this array.
	public func remove(at index: Int) {
		arrayRemoveElement(self.arrayPointer, Int64(index))
	}

	/// Remove all the elements from this array.
	public func clear() {
		arrayClear(self.arrayPointer)
	}

	// MARK: - Protocol Functions

	public static func == (lhs: TOMLArray, rhs: TOMLArray) -> Bool {
		arrayEqual(lhs.arrayPointer, rhs.arrayPointer)
	}

	public func next() -> TOMLValue? {
		guard self.currentIndex <= self.endIndex else { return nil }

		self.currentIndex += 1
		guard let pointer = arrayGetNode(self.arrayPointer, Int64(self.currentIndex)) else { return nil }
		return TOMLValue(tomlValuePointer: pointer)
	}

	public func insertIntoTable(tablePointer: OpaquePointer, key: String) {
		tableInsertArray(tablePointer, strdup(key), self.arrayPointer)
	}

	public func insertIntoArray(arrayPointer: OpaquePointer, index: Int) {
		arrayInsertArray(arrayPointer, Int64(index), self.arrayPointer)
	}
}
