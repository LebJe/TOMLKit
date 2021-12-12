// Copyright (c) 2021 Jeff Lebrun
//
//  Licensed under the MIT License.
//
//  The full text of the license can be found in the file named LICENSE.

import struct Foundation.Data

/// `TOMLDecoder` decodes TOML documents into Swift `struct`s.
///
/// ### Customizing Decoding
///
/// By default, `Data` is decoded using Base64, but you can use another method by providing a function to ``TOMLDecoder/dataDecoder``:
/// ```swift
/// let toml = "data = [83, 71, 86, 115, 98, 71, 56, 103, 86, 50, 57, 121, 98, 71, 81, 104]"
///
/// var decoder = TOMLDecoder()
///
/// decoder.dataDecoder = {
/// 	let arr = $0.array!.map({ UInt8($0.int!) })
/// 	return Data(base64Encoded: Data(arr))!
/// }
///
/// let myStruct = try decoder.decode(MyStruct.self, from: toml)
/// String(data: myStruct.data, encoding: .utf8) // <== "Hello World!"
/// ```
public struct TOMLDecoder {
	public var userInfo: [CodingUserInfoKey: Any] = [:]

	/// This function will be used to decode `Data` in a TOML document.
	///
	/// The default decoding mechanism is [Base64](https://en.wikipedia.org/wiki/Base64).
	public var dataDecoder: (TOMLValueConvertible) -> Data? = { $0.string != nil ? Data(base64Encoded: $0.string!) : nil }

	public init(
		dataDecoder: @escaping (TOMLValueConvertible) -> Data? = { $0.string != nil ? Data(base64Encoded: $0.string!) : nil }
	) {
		self.dataDecoder = dataDecoder
	}

	/// Decodes `T` from a TOML string.
	/// - Parameters:
	///   - type: The type you want to convert `tomlString` to.
	///   - tomlString: The `String` containing the TOML document.
	/// - Throws: ``TOMLParseError`` and `DecodingError`.
	/// - Returns: The decoded type.
	public func decode<T: Decodable>(_ type: T.Type, from tomlString: String) throws -> T {
		let table = try TOMLTable(string: tomlString)
		let decoder = InternalTOMLDecoder(table.tomlValue, userInfo: self.userInfo, dataDecoder: self.dataDecoder)
		return try T(from: decoder)
	}

	/// Decodes `T` from a ``TOMLTable``.
	/// - Parameters:
	///   - type: The type you want to convert `table` to.
	///   - table: The ``TOMLTable`` that you want to convert to `T`.
	/// - Throws: `DecodingError`.
	/// - Returns: The decoded type.
	public func decode<T: Decodable>(_ type: T.Type, from table: TOMLTable) throws -> T {
		let decoder = InternalTOMLDecoder(table.tomlValue, userInfo: self.userInfo, dataDecoder: self.dataDecoder)
		return try T(from: decoder)
	}
}
