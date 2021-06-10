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
}

/// Formatting options that are used when converting a `TOMLTable` to a JSON or TOML document.
public struct FormatOptions: OptionSet {
	public let rawValue: UInt8

	public init(rawValue: UInt8) {
		self.rawValue = rawValue
	}

	/// Dates and times will be emitted as quoted strings.
	///
	/// This documentation comment was taken from the [toml++ documentation](https://marzer.github.io/tomlplusplus/namespacetoml.html#af1a6761a2f4d80b1a541ba819d9c8e0fa6e569050aafc6eca4c0c5dfab35fd25a) .
	public static let quoteDateAndTimes = Self(rawValue: 1)

	/// Strings will be emitted as single-quoted literal strings where possible.
	///
	/// This documentation comment was taken from the [toml++ documentation](https://marzer.github.io/tomlplusplus/namespacetoml.html#af1a6761a2f4d80b1a541ba819d9c8e0fa328473763ff1ab919ce0b01d66ad3bf6) .
	public static let allowLiteralStrings = Self(rawValue: 2)

	/// Strings containing newlines will be emitted as triple-quoted 'multi-line' strings where possible.
	///
	/// This documentation comment was taken from the [toml++ documentation](https://marzer.github.io/tomlplusplus/namespacetoml.html#af1a6761a2f4d80b1a541ba819d9c8e0fad9467c39215be4189dc8395a830f9051) .
	public static let allowMultilineStrings = Self(rawValue: 4)

	/// Values with special format flags will be formatted accordingly.
	///
	/// This documentation comment was taken from the [toml++ documentation](https://marzer.github.io/tomlplusplus/namespacetoml.html#af1a6761a2f4d80b1a541ba819d9c8e0fa03f40167237c22f11f9bcf825269ab40).
	public static let allowValueFormatFlags = Self(rawValue: 8)
}
