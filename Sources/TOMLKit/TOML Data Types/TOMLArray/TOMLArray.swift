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

/// An [array](https://toml.io/en/v1.0.0#array) in a TOML document.
public final class TOMLArray:
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

	public var count: Int { arraySize(self.arrayPointer) }

	/// If this array is empty.
	public var isEmpty: Bool { arrayIsEmpty(self.arrayPointer) }

	public var debugDescription: String {
		String(cString: arrayConvertToTOML(self.arrayPointer))
		// "[\(self.map({ "\($0.debugDescription)" }).joined(separator: ", "))]"
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

	/// Creates a new `TOMLArray` using the contents of a Swift `Array`.
	public convenience init(_ array: [TOMLValueConvertible]) {
		self.init()
		array.forEach(self.append(_:))
	}

	public convenience init(arrayLiteral: TOMLValueConvertible...) {
		self.init(arrayLiteral)
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
