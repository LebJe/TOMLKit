// Copyright (c) 2021 Jeff Lebrun
//
//  Licensed under the MIT License.
//
//  The full text of the license can be found in the file named LICENSE.

import struct Foundation.Data

enum Either<Left, Right> {
	case left(Left)
	case right(Right)
}

final class InternalTOMLEncoder: Encoder {
	var codingPath: [CodingKey]
	var userInfo: [CodingUserInfoKey: Any]
	let tomlValueOrArray: Either<TOMLValue, (array: TOMLArray, index: Int)>
	let parentKey: CodingKey?
	let dataEncoder: (Data) -> String

	init(
		_ tomlValueOrArray: Either<TOMLValue, (array: TOMLArray, index: Int)>,
		parentKey: CodingKey? = nil,
		codingPath: [CodingKey],
		userInfo: [CodingUserInfoKey: Any],
		dataEncoder: @escaping (Data) -> String
	) {
		self.tomlValueOrArray = tomlValueOrArray
		self.parentKey = parentKey
		self.userInfo = userInfo
		self.codingPath = codingPath
		self.dataEncoder = dataEncoder
	}

	func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {
		switch self.tomlValueOrArray {
			case let .left(value):
				return KeyedEncodingContainer(
					KEC(
						value,
						parentKey: self.parentKey,
						codingPath: self.codingPath,
						userInfo: self.userInfo,
						dataEncoder: self.dataEncoder
					)
				)
			case let .right((array, index)):
				let table = TOMLTable()
				array[index] = table
				return KeyedEncodingContainer(
					KEC(
						array[index].tomlValue,
						parentKey: self.parentKey,
						codingPath: self.codingPath,
						userInfo: self.userInfo,
						dataEncoder: self.dataEncoder
					)
				)
		}
	}

	func unkeyedContainer() -> UnkeyedEncodingContainer {
		if let parentKey = parentKey {
			switch self.tomlValueOrArray {
				case let .left(value):
					value.table?[parentKey.stringValue] = TOMLArray()
					return UEC(
						value.table![parentKey.stringValue]!.array!,
						codingPath: self.codingPath,
						userInfo: self.userInfo,
						dataEncoder: self.dataEncoder
					)
				case let .right((containerArray, index)):
					containerArray[index] = TOMLArray()
					return UEC(
						containerArray[index].array!,
						codingPath: self.codingPath,
						userInfo: self.userInfo,
						dataEncoder: self.dataEncoder
					)
			}
		} else {
			return UEC(
				TOMLArray(),
				codingPath: self.codingPath,
				userInfo: self.userInfo,
				dataEncoder: self.dataEncoder
			)
		}
	}

	func singleValueContainer() -> SingleValueEncodingContainer {
		switch self.tomlValueOrArray {
			case let .left(value):
				return SVEC(
					.left(value),
					parentKey: self.parentKey!,
					userInfo: self.userInfo,
					dataEncoder: self.dataEncoder
				)
			case let .right((array, index)):
				return SVEC(
					.right((array: array, index: index)),
					parentKey: nil,
					userInfo: self.userInfo,
					dataEncoder: self.dataEncoder
				)
		}
	}

	final class SVEC: SingleValueEncodingContainer {
		var codingPath: [CodingKey]
		var userInfo: [CodingUserInfoKey: Any]
		let tomlValueOrArray: Either<TOMLValue, (array: TOMLArray, index: Int)>
		let parentKey: CodingKey?
		let dataEncoder: (Data) -> String

		init(
			_ tomlValueOrArray: Either<TOMLValue, (array: TOMLArray, index: Int)>,
			parentKey: CodingKey?,
			userInfo: [CodingUserInfoKey: Any] = [:],
			dataEncoder: @escaping (Data) -> String
		) {
			self.tomlValueOrArray = tomlValueOrArray
			self.parentKey = parentKey
			self.userInfo = userInfo
			self.codingPath = []
			self.dataEncoder = dataEncoder
		}
	}

	final class KEC<Key: CodingKey>: KeyedEncodingContainerProtocol {
		var codingPath: [CodingKey]
		var userInfo: [CodingUserInfoKey: Any]
		let tomlValue: TOMLValue
		let parentKey: CodingKey?
		let dataEncoder: (Data) -> String

		init(
			_ tomlValue: TOMLValue,
			parentKey: CodingKey? = nil,
			codingPath: [CodingKey],
			userInfo: [CodingUserInfoKey: Any] = [:],
			dataEncoder: @escaping (Data) -> String
		) {
			self.tomlValue = tomlValue
			self.parentKey = parentKey
			self.userInfo = userInfo
			self.codingPath = codingPath
			self.dataEncoder = dataEncoder
		}
	}

	struct UEC: UnkeyedEncodingContainer {
		var codingPath: [CodingKey]
		var userInfo: [CodingUserInfoKey: Any] = [:]
		let dataEncoder: (Data) -> String
		var currentIndex: Int = 0
		let tomlArray: TOMLArray

		var count: Int {
			self.tomlArray.count
		}

		init(
			_ tomlArray: TOMLArray,
			codingPath: [CodingKey],
			userInfo: [CodingUserInfoKey: Any],
			dataEncoder: @escaping (Data) -> String
		) {
			self.tomlArray = tomlArray
			self.codingPath = codingPath
			self.userInfo = userInfo
			self.dataEncoder = dataEncoder
		}
	}
}
