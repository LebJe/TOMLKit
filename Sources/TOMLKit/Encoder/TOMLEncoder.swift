// Copyright (c) 2021 Jeff Lebrun
//
//  Licensed under the MIT License.
//
//  The full text of the license can be found in the file named LICENSE.

import struct Foundation.Data

/// `TOMLEncoder` encodes Swift `struct`s into TOML documents.
public struct TOMLEncoder {
	public var userInfo: [CodingUserInfoKey: Any] = [:]

	/// Once encoding is complete, `options` will be used when converting the encoded data into TOML.
	public var options: FormatOptions = [
		.allowLiteralStrings,
		.allowMultilineStrings,
		//.allowValueFormatFlags,
	]

	/// Used to encode instances of `Data` into a type conforming to `TOMLValueConvertible` that can be inserted into a TOML document.
	///
	/// The default `Data` encoding is [Base64](https://en.wikipedia.org/wiki/Base64).
	public var dataEncoder: (Data) -> TOMLValueConvertible = { $0.base64EncodedString() }

	public init(
		options: FormatOptions = [
			.allowLiteralStrings,
			.allowMultilineStrings,
			//.allowValueFormatFlags,
		],
		dataEncoder: @escaping (Data) -> TOMLValueConvertible = { $0.base64EncodedString() }
	) {
		self.options = options
		self.dataEncoder = dataEncoder
	}

	/// Encodes `T` and returns the generated TOML.
	/// - Parameters:
	///   - value: The type you want to convert into TOML.
	/// - Throws: `EncodingError`.
	/// - Returns: The generated TOML.
	public func encode<T: Encodable>(_ value: T) throws -> String {
		try self.encode(value).convert(to: .toml, options: self.options)
	}

	/// Encodes `T` and returns the generated ``TOMLTable``.
	/// - Parameters:
	///   - value: The type you want to convert into a ``TOMLTable``.
	/// - Throws: `EncodingError`.
	/// - Returns: The generated ``TOMLTable`` containing the contents of `T`.
	@_disfavoredOverload
	public func encode<T: Encodable>(_ value: T) throws -> TOMLTable {
		let table = TOMLTable()

		let encoder = InternalTOMLEncoder(
			.left(table.tomlValue),
			codingPath: [],
			userInfo: self.userInfo,
			dataEncoder: self.dataEncoder
		)

		try value.encode(to: encoder)
		return table
	}
}
