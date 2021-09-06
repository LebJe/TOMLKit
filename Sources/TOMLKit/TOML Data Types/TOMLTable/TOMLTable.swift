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

/// A [table](https://toml.io/en/v1.0.0#table) in a TOML document.
public final class TOMLTable:
	Equatable,
	ExpressibleByDictionaryLiteral,
	CustomDebugStringConvertible,
	TOMLValueConvertible,
	Sequence
{
	public var type: TOMLType { .table }
	public var debugDescription: String { self.convert() }
	public var tomlValue: TOMLValue { get { .init(self) } set {} }

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
	internal var tablePointer: OpaquePointer

	/// The amount of elements in the table.
	public var count: Int { tableSize(self.tablePointer) }

	/// Whether the table is empty or not.
	public var isEmpty: Bool { tableIsEmpty(self.tablePointer) }

	/// Whether every element in the table is of the same type.
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
	public convenience init(_ dictionary: [String: TOMLValueConvertible], inline: Bool = false) {
		self.init(inline: inline)
		dictionary.forEach({ self[$0] = $1 })
	}

	/// Creates a `TOMLTable` from a `String` containing a TOML document.
	/// - Parameters:
	///   - string: The `String` containing a TOML document.
	/// - Throws: `TOMLParseError` if an error occurs during parsing.
	public init(string: String) throws {
		let errorPointer = UnsafeMutablePointer<CTOMLParseError>.allocate(capacity: 1)

		guard let table = string.withCString({ tableCreateFromString($0, errorPointer) }) else {
			throw TOMLParseError(cTOMLParseError: errorPointer.pointee)
		}

		self.tablePointer = table
	}

	public required convenience init(dictionaryLiteral elements: (String, TOMLValueConvertible)...) {
		self.init()
		elements.forEach({ self[$0] = $1 })
	}

	init(tablePointer: OpaquePointer) {
		self.tablePointer = tablePointer
	}

	/// Removes all the values from the table.
	public func clear() {
		tableClear(self.tablePointer)
	}

	/// Insert a value into this `TOMLTable`, or retrieve a value.
	public subscript(key: String) -> TOMLValueConvertible? {
		get {
			guard let pointer = tableGetNode(self.tablePointer, strdup(key)) else { return nil }
			return TOMLValue(tomlValuePointer: pointer)
		}
		set(value) {
			value?.tomlValue.replaceOrInsertInTable(tablePointer: self.tablePointer, key: key)
		}
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

	// MARK: - Protocol Functions

	public static func == (lhs: TOMLTable, rhs: TOMLTable) -> Bool {
		tableEqual(lhs.tablePointer, rhs.tablePointer)
	}

	func insertIntoTable(tablePointer: OpaquePointer, key: String) {
		tableInsertTable(tablePointer, strdup(key), self.tablePointer)
	}

	func insertIntoArray(arrayPointer: OpaquePointer, index: Int) {
		arrayInsertTable(arrayPointer, Int64(index), self.tablePointer)
	}
}
