// Copyright (c) 2021 Jeff Lebrun
//
//  Licensed under the MIT License.
//
//  The full text of the license can be found in the file named LICENSE.

/// `TOMLDecoder` decodes TOML documents into Swift `struct`s.
public struct TOMLDecoder {
	public var userInfo: [CodingUserInfoKey: Any] = [:]

	public init() {}

	/// Decodes `T` from a TOML string.
	/// - Parameters:
	///   - type: The type you want to convert `tomlString` to.
	///   - tomlString: The `String` containing the TOML document.
	/// - Throws: `TOMLParseError` and `DecodingError`.
	/// - Returns: The decoded type.
	public func decode<T: Decodable>(_ type: T.Type, from tomlString: String) throws -> T {
		let table = try TOMLTable(string: tomlString)
		let decoder = InternalTOMLDecoder(table.tomlValue)
		return try T(from: decoder)
	}

	/// Decodes `T` from a `TOMLTable`.
	/// - Parameters:
	///   - type: The type you want to convert `table` to.
	///   - table: The `TOMLTable` that you want to convert to `T`.
	/// - Throws: `DecodingError`.
	/// - Returns: The decoded type.
	public func decode<T: Decodable>(_ type: T.Type, from table: TOMLTable) throws -> T {
		let decoder = InternalTOMLDecoder(table.tomlValue)
		return try T(from: decoder)
	}
}
