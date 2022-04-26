// Copyright (c) 2022 Jeff Lebrun
//
//  Licensed under the MIT License.
//
//  The full text of the license can be found in the file named LICENSE.

import struct Foundation.Data

final class InternalTOMLDecoder: Decoder {
	var codingPath: [CodingKey] = []
	var userInfo: [CodingUserInfoKey: Any] = [:]
	var dataDecoder: (TOMLValueConvertible) -> Data?

	let tomlValue: TOMLValue
	init(
		_ tomlValue: TOMLValue,
		userInfo: [CodingUserInfoKey: Any] = [:],
		codingPath: [CodingKey] = [],
		dataDecoder: @escaping (TOMLValueConvertible) -> Data?
	) {
		self.tomlValue = tomlValue
		self.userInfo = userInfo
		self.codingPath = codingPath
		self.dataDecoder = dataDecoder
	}

	func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
		guard let table = self.tomlValue.table else {
			throw DecodingError.typeMismatch(
				TOMLTable.self,
				DecodingError
					.Context(
						codingPath: self.codingPath,
						debugDescription: "Expected a table, but found a \(self.tomlValue.type.description) instead."
					)
			)
		}

		return KeyedDecodingContainer<Key>(
			KDC(
				table: table,
				codingPath: self.codingPath,
				userInfo: self.userInfo,
				dataDecoder: self.dataDecoder
			)
		)
	}

	func unkeyedContainer() throws -> UnkeyedDecodingContainer {
		guard let array = self.tomlValue.array else {
			throw DecodingError.typeMismatch(
				TOMLArray.self,
				DecodingError.Context(
					codingPath: self.codingPath,
					debugDescription: "Expected a TOMLArray but found a \(self.tomlValue.type.description) instead."
				)
			)
		}
		return UDC(array, codingPath: self.codingPath, userInfo: self.userInfo, dataDecoder: self.dataDecoder)
	}

	func singleValueContainer() throws -> SingleValueDecodingContainer {
		SVDC(self.tomlValue, codingPath: self.codingPath, dataDecoder: self.dataDecoder)
	}

	struct SVDC: SingleValueDecodingContainer {
		var codingPath: [CodingKey] = []
		var userInfo: [CodingUserInfoKey: Any] = [:]
		var dataDecoder: (TOMLValueConvertible) -> Data?
		let tomlValue: TOMLValue

		init(
			_ tomlValue: TOMLValue,
			codingPath: [CodingKey],
			userInfo: [CodingUserInfoKey: Any] = [:],
			dataDecoder: @escaping (TOMLValueConvertible) -> Data?
		) {
			self.tomlValue = tomlValue
			self.userInfo = userInfo
			self.codingPath = codingPath
			self.dataDecoder = dataDecoder
		}
	}

	struct KDC<Key: CodingKey>: KeyedDecodingContainerProtocol {
		var codingPath: [CodingKey] = []
		var userInfo: [CodingUserInfoKey: Any] = [:]
		var dataDecoder: (TOMLValueConvertible) -> Data?
		var allKeys: [Key] = []
		let tomlValue: TOMLTable

		init(
			table: TOMLTable,
			codingPath: [CodingKey],
			userInfo: [CodingUserInfoKey: Any],
			dataDecoder: @escaping (TOMLValueConvertible) -> Data?
		) {
			self.tomlValue = table
			self.userInfo = userInfo
			self.codingPath = codingPath
			self.dataDecoder = dataDecoder
			self.allKeys = tomlValue.keys.compactMap(Self.Key.init(stringValue:))
		}
	}

	struct UDC: UnkeyedDecodingContainer {
		var codingPath: [CodingKey]
		var userInfo: [CodingUserInfoKey: Any] = [:]
		var dataDecoder: (TOMLValueConvertible) -> Data?

		var count: Int? { self.tomlArray.count }

		var isAtEnd: Bool {
			guard let count = self.count else { return true }
			return self.currentIndex >= count
		}

		var currentIndex: Int = 0

		let tomlArray: TOMLArray

		init(
			_ tomlArray: TOMLArray,
			codingPath: [CodingKey],
			userInfo: [CodingUserInfoKey: Any],
			dataDecoder: @escaping (TOMLValueConvertible) -> Data?
		) {
			self.tomlArray = tomlArray
			self.codingPath = codingPath
			self.userInfo = userInfo
			self.dataDecoder = dataDecoder
		}
	}
}
