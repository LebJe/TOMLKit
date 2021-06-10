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
	// TODO: is this the right module?
	import ucrt
#else
	#error("Unsupported Platform")
#endif

import CTOML

/// A table in a TOML document.
public class TOMLTable:
	Equatable,
	ExpressibleByDictionaryLiteral,
	CustomDebugStringConvertible,
	TOMLValueConvertible,
	Sequence,
	IteratorProtocol
{
	public typealias Element = (String, TOMLValue)

	private var currentIndex = 0

	private var storedKeys: [String] = []
	private var storedValues: [TOMLValue] = []

	public var type: TOMLType { .table }

	public var debugDescription: String { self.convert() }

	/// An `Array` of the keys in this table.
	public var keys: [String] {
		let pointer = tableGetKeys(self.tablePointer)
		var keyArray: [String] = []
		for i in 0..<self.count {
			keyArray.append(String(cString: pointer[i]))
		}

		return keyArray
	}

	/// An `Array` of the `TOMValue`s in this table.
	public var values: [TOMLValue] {
		let pointer = tableGetValues(self.tablePointer)
		var tomlValueArray: [TOMLValue] = []
		for i in 0..<self.count {
			tomlValueArray.append(TOMLValue(tomlValuePointer: pointer[i]))
		}

		return tomlValueArray
	}

	/// Whether this `TOMLTable` is an [inline table](https://toml.io/en/v1.0.0#inline-table) or not.
	///
	/// Use the `get`ter to check if this table in an inline table, and use the `set`ter to make this an inline table.
	public var inline: Bool {
		get { tableInline(self.tablePointer) }
		set { tableSetInline(self.tablePointer, newValue) }
	}

	/// A pointer to the underlying `toml::table`.
	private var tablePointer: OpaquePointer

	var tomlValue: TOMLValue {
		TOMLValue(tomlValuePointer: self.tablePointer)
	}

	/// The amount of elements in the table.
	public var count: Int {
		tableSize(self.tablePointer)
	}

	/// Whether the table is empty or not.
	public var isEmpty: Bool {
		tableIsEmpty(self.tablePointer)
	}

	public var isHomogeneous: Bool {
		tableIsHomogeneous(self.tablePointer)
	}

	private var defaultTOMLConverterFlags: FormatOptions = [
		.allowLiteralStrings,
		.allowMultilineStrings,
		.allowValueFormatFlags,
	]

	private var defaultJSONConverterFlags: FormatOptions = .quoteDateAndTimes

	/// Create a new `TOMLTable`.
	/// - Parameter inline: Whether this table will be an [inline table](https://toml.io/en/v1.0.0#inline-table) or not.
	public init(inline: Bool = false) {
		self.tablePointer = tableCreate()
		self.inline = inline
	}

	/// Creates a new `TOMLTable` from a dictionary,
	/// - Parameters:
	///   - dictionary: The `Dictionary` that will be used to populate the fields of this table.
	///   - inline: Whether this table will be an [inline table](https://toml.io/en/v1.0.0#inline-table) or not.
	public init(_ dictionary: [String: TOMLValueConvertible], inline: Bool = false) {
		self.tablePointer = tableCreate()
		self.inline = inline
		dictionary.forEach({ self[$0] = $1 })
	}

	/// Creates a `TOMLTable` from a `String` containing a TOML document.
	/// - Parameters:
	///   - string: The `String` containing a TOML document.
	///   - inline: Whether this table will be an [inline table](https://toml.io/en/v1.0.0#inline-table) or not.
	/// - Throws: `TOMLParseError` if an error occurs during parsing.
	public init(string: String, inline: Bool = false) throws {
		let errorPointer = UnsafeMutablePointer<CTOMLParseError>.allocate(capacity: 1)

		guard let table = string.withCString({ tableCreateFromString($0, errorPointer) }) else {
			throw TOMLParseError(cTOMLParseError: errorPointer.pointee)
		}

		self.tablePointer = table
		self.inline = inline
	}

	public required init(dictionaryLiteral elements: (String, TOMLValueConvertible)...) {
		self.tablePointer = tableCreate()
		elements.forEach({ self[$0] = $1 })
	}

	init(tablePointer: OpaquePointer) {
		self.tablePointer = tablePointer
	}

	/// Removes all the values from the table.
	public func clear() {
		tableClear(self.tablePointer)
	}

	public func insert(_ value: TOMLValueConvertible, at key: String) {
		value.insertIntoTable(tablePointer: self.tablePointer, key: key)
	}

	/// Remove the element at `key` from this table.
	public func remove(at key: String) {
		tableRemoveElement(self.tablePointer, strdup(key))
	}

	/// Converts this `TOMLTable` to a JSON or TOML document.
	/// - Parameter format: The format you want to convert `self` to.
	/// - Returns: The `String` containing the JSON or TOML document.
	public func convert(to format: ConversionFormat = .toml, options: FormatOptions = []) -> String {
		switch format {
			case .toml: return String(cString: tableConvertToTOML(self.tablePointer, (options.isEmpty ? self.defaultTOMLConverterFlags : options).rawValue))
			case .json: return String(cString: tableConvertToJSON(self.tablePointer, (options.isEmpty ? self.defaultJSONConverterFlags : options).rawValue))
		}
	}

	/// Insert a value into this table.
	public subscript(key: String) -> TOMLValueConvertible {
		get { fatalError("Use \"subscript(key: String) -> TOMLValue?\"") }

		set(value) {
			value.insertIntoTable(tablePointer: self.tablePointer, key: key)
		}
	}

	// MARK: - Protocol Functions

	public static func == (lhs: TOMLTable, rhs: TOMLTable) -> Bool {
		tableEqual(lhs.tablePointer, rhs.tablePointer)
	}

	public func next() -> (String, TOMLValue)? {
		if self.currentIndex == 0 {
			self.storedKeys = self.keys
			self.storedValues = self.values
		}
		guard self.currentIndex <= self.count else {
			self.currentIndex = 0
			self.storedKeys = []
			self.storedValues = []
			return nil
		}

		let v = (self.storedKeys[self.currentIndex], self.storedValues[self.currentIndex])
		self.currentIndex += 1

		return v
	}

	public func insertIntoTable(tablePointer: OpaquePointer, key: String) {
		tableInsertTable(tablePointer, strdup(key), self.tablePointer)
	}

	public func insertIntoArray(arrayPointer: OpaquePointer, index: Int) {
		arrayInsertTable(arrayPointer, Int64(index), self.tablePointer)
	}

	public subscript(key: String) -> TOMLValue? {
		guard let pointer = tableGetNode(self.tablePointer, strdup(key)) else { return nil }
		return TOMLValue(tomlValuePointer: pointer)
	}
}
