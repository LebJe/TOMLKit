// Copyright (c) 2021 Jeff Lebrun
//
//  Licensed under the MIT License.
//
//  The full text of the license can be found in the file named LICENSE.

final class InternalTOMLDecoder: Decoder {
	var codingPath: [CodingKey] = []
	var userInfo: [CodingUserInfoKey: Any] = [:]

	let tomlValue: TOMLValue
	init(_ tomlValue: TOMLValue, userInfo: [CodingUserInfoKey: Any] = [:]) {
		self.tomlValue = tomlValue
		self.userInfo = userInfo
	}

	func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
		KeyedDecodingContainer<Key>(KDC(tomlValue: self.tomlValue, codingPath: self.codingPath, userInfo: self.userInfo))
	}

	func unkeyedContainer() throws -> UnkeyedDecodingContainer {
		guard let array = self.tomlValue.array else {
			throw DecodingError.typeMismatch(TOMLArray.self, DecodingError.Context(codingPath: self.codingPath, debugDescription: "Expected a TOMLArray but found a \(self.tomlValue.type) instead."))
		}
		return UDC(array, codingPath: self.codingPath, userInfo: self.userInfo)
	}

	func singleValueContainer() throws -> SingleValueDecodingContainer {
		SVDC(self.tomlValue, codingPath: self.codingPath)
	}

	struct SVDC: SingleValueDecodingContainer {
		var codingPath: [CodingKey] = []
		var userInfo: [CodingUserInfoKey: Any] = [:]
		let tomlValue: TOMLValue

		init(_ tomlValue: TOMLValue, codingPath: [CodingKey], userInfo: [CodingUserInfoKey: Any] = [:]) {
			self.tomlValue = tomlValue
			self.userInfo = userInfo
			self.codingPath = codingPath
		}
	}

	struct KDC<Key: CodingKey>: KeyedDecodingContainerProtocol {
		var codingPath: [CodingKey] = []
		var userInfo: [CodingUserInfoKey: Any] = [:]
		var allKeys: [Key] = []
		let tomlValue: TOMLValue

		init(tomlValue: TOMLValue, codingPath: [CodingKey], userInfo: [CodingUserInfoKey: Any]) {
			self.tomlValue = tomlValue
			self.userInfo = userInfo
			self.codingPath = codingPath
		}
	}

	struct UDC: UnkeyedDecodingContainer {
		var codingPath: [CodingKey]
		var userInfo: [CodingUserInfoKey: Any] = [:]

		var count: Int? {
			self.tomlArray.count
		}

		var isAtEnd: Bool {
			guard let count = self.count else {
				return true
			}

			return self.currentIndex >= count
		}

		var currentIndex: Int = 0

		let tomlArray: TOMLArray

		init(_ tomlArray: TOMLArray, codingPath: [CodingKey], userInfo: [CodingUserInfoKey: Any]) {
			self.tomlArray = tomlArray
			self.codingPath = codingPath
			self.userInfo = userInfo
		}
	}
}
