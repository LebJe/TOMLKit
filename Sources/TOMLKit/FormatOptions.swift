// Copyright (c) 2021 Jeff Lebrun
//
//  Licensed under the MIT License.
//
//  The full text of the license can be found in the file named LICENSE.

/// The format to convert a `TOMLTable` to.
public enum ConversionFormat {
	/// The [TOML](https://toml.io) format.
	case toml

	/// The [JSON](https://www.json.org/) format.
	case json

	/// The [YAML](https://yaml.org) format.
	case yaml
}

/// Formatting options that are used when converting a `TOMLTable` to a JSON, YAML, or TOML document.
public struct FormatOptions: OptionSet {
	public let rawValue: UInt64

	public init(rawValue: UInt64) {
		self.rawValue = rawValue
	}

	/// Dates and times will be emitted as quoted strings.
	///
	/// This documentation comment was taken from the [toml++ documentation](https://marzer.github.io/tomlplusplus/namespacetoml.html#af1a6761a2f4d80b1a541ba819d9c8e0fa6e569050aafc6eca4c0c5dfab35fd25a).
	public static let quoteDateAndTimes = Self(rawValue: 1)

	/// Infinities and NaNs will be emitted as quoted strings.
	public static let quoteInfinitesAndNaNs = Self(rawValue: 2)

	/// Strings will be emitted as single-quoted literal strings where possible.
	///
	/// This documentation comment was taken from the [toml++ documentation](https://marzer.github.io/tomlplusplus/namespacetoml.html#af1a6761a2f4d80b1a541ba819d9c8e0fa328473763ff1ab919ce0b01d66ad3bf6).
	public static let allowLiteralStrings = Self(rawValue: 4)

	/// Strings containing newlines will be emitted as triple-quoted 'multi-line' strings where possible.
	///
	/// This documentation comment was taken from the [toml++ documentation](https://marzer.github.io/tomlplusplus/namespacetoml.html#af1a6761a2f4d80b1a541ba819d9c8e0fad9467c39215be4189dc8395a830f9051).
	public static let allowMultilineStrings = Self(rawValue: 8)

	/// Allow real tab characters in string literals (as opposed to the escaped form `\t`).
	public static let allowRealTabsInStrings = Self(rawValue: 16)

	/// Allow integers with ``ValueOptions/formatAsBinary`` to be emitted as binary.
	public static let allowBinaryIntegers = Self(rawValue: 32)

	/// Allow integers with ``ValueOptions/formatAsOctal`` to be emitted as octal.
	public static let allowOctalIntegers = Self(rawValue: 64)

	/// Allow integers with ``ValueOptions/formatAsHexadecimal`` to be emitted as hexadecimal.
	public static let allowHexadecimalIntegers = Self(rawValue: 128)

	/// Apply indentation to tables nested within other tables/arrays.
	public static let indentSubTables = Self(rawValue: 256)

	/// Apply indentation to array elements when the array is forced to wrap over multiple lines.
	public static let indentArrayElements = Self(rawValue: 512)

	/// Combination mask of all indentation-enabling flags.
	public static let indentations = Self(rawValue: FormatOptions.indentSubTables.rawValue | FormatOptions.indentArrayElements.rawValue)

	/// Values with special format flags will be formatted accordingly.
	///
	/// This documentation comment was taken from the [toml++ documentation](https://marzer.github.io/tomlplusplus/namespacetoml.html#af1a6761a2f4d80b1a541ba819d9c8e0fa03f40167237c22f11f9bcf825269ab40).
}
