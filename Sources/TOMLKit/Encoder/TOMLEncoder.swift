// Copyright (c) 2021 Jeff Lebrun
//
//  Licensed under the MIT License.
//
//  The full text of the license can be found in the file named LICENSE.

/// `TOMLEncoder` encodes Swift `struct`s into TOML documents.
public struct TOMLEncoder {
	public var userInfo: [CodingUserInfoKey: Any] = [:]
	public var options: FormatOptions = [
		.allowLiteralStrings,
		.allowMultilineStrings,
		.allowValueFormatFlags,
	]

	public init(
		options: FormatOptions = [
			.allowLiteralStrings,
			.allowMultilineStrings,
			.allowValueFormatFlags,
		]
	) {
		self.options = options
	}

	/// Encodes `T` and returns the generated TOML.
	/// - Parameters:
	///   - value: The type you want to convert  into TOML.
	/// - Throws: `EncodingError`.
	/// - Returns: The generated TOML.
	public func encode<T: Encodable>(_ value: T) throws -> String {
		let table = TOMLTable()
		let encoder = InternalTOMLEncoder(.left(table.tomlValue), codingPath: [], userInfo: self.userInfo)
		try value.encode(to: encoder)
		return table.convert(to: .toml, options: self.options)
	}
}
