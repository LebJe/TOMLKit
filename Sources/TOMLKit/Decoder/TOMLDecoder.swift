// Copyright (c) 2021 Jeff Lebrun
//
//  Licensed under the MIT License.
//
//  The full text of the license can be found in the file named LICENSE.

import struct Foundation.Data

/// `TOMLDecoder` decodes TOML documents into Swift `struct`s.
public struct TOMLDecoder {
	public var userInfo: [CodingUserInfoKey: Any] = [:]

	/// This function will be used to decode instances of `Data` from a `String` in a TOML document.
	///
	/// The default decoding mechanism is [Base64](https://en.wikipedia.org/wiki/Base64).
	public var dataDecoder: (String) -> Data? = { Data(base64Encoded: $0) }

	public init(dataDecoder: @escaping (String) -> Data? = { Data(base64Encoded: $0) }) {
		self.dataDecoder = dataDecoder
	}

	/// Decodes `T` from a TOML string.
	/// - Parameters:
	///   - type: The type you want to convert `tomlString` to.
	///   - tomlString: The `String` containing the TOML document.
	/// - Throws: `TOMLParseError` and `DecodingError`.
	/// - Returns: The decoded type.
	public func decode<T: Decodable>(_ type: T.Type, from tomlString: String) throws -> T {
		let table = try TOMLTable(string: tomlString)
		let decoder = InternalTOMLDecoder(table.tomlValue, userInfo: self.userInfo, dataDecoder: self.dataDecoder)
		return try T(from: decoder)
	}

	/// Decodes `T` from a `TOMLTable`.
	/// - Parameters:
	///   - type: The type you want to convert `table` to.
	///   - table: The `TOMLTable` that you want to convert to `T`.
	/// - Throws: `DecodingError`.
	/// - Returns: The decoded type.
	public func decode<T: Decodable>(_ type: T.Type, from table: TOMLTable) throws -> T {
		let decoder = InternalTOMLDecoder(table.tomlValue, userInfo: self.userInfo, dataDecoder: self.dataDecoder)
		return try T(from: decoder)
	}
}
