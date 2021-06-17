// Copyright (c) 2021 Jeff Lebrun
//
//  Licensed under the MIT License.
//
//  The full text of the license can be found in the file named LICENSE.

enum Either<Left, Right> {
	case left(Left)
	case right(Right)
}

final class InternalTOMLEncoder: Encoder {
	var codingPath: [CodingKey]

	var userInfo: [CodingUserInfoKey: Any]

	let tomlValueOrArray: Either<TOMLValue, (array: TOMLArray, index: Int)>

	let parentKey: CodingKey?

	init(_ tomlValueOrArray: Either<TOMLValue, (array: TOMLArray, index: Int)>, parentKey: CodingKey? = nil, codingPath: [CodingKey], userInfo: [CodingUserInfoKey: Any]) {
		self.tomlValueOrArray = tomlValueOrArray
		self.parentKey = parentKey
		self.userInfo = userInfo
		self.codingPath = codingPath
	}

	func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {
		switch self.tomlValueOrArray {
			case let .left(value):
				return KeyedEncodingContainer(KEC(value, parentKey: self.parentKey, codingPath: self.codingPath, userInfo: self.userInfo))
			case let .right((array, index)):
				let table = TOMLTable()
				array[index] = table
				return KeyedEncodingContainer(KEC(array[index].tomlValue, parentKey: self.parentKey, codingPath: self.codingPath, userInfo: self.userInfo))
		}
	}

	func unkeyedContainer() -> UnkeyedEncodingContainer {
		if let parentKey = parentKey {
			switch self.tomlValueOrArray {
				case let .left(value):
					value.table?[parentKey.stringValue] = TOMLArray()
					return UEC(value.table![parentKey.stringValue]!.array!, codingPath: self.codingPath, userInfo: self.userInfo)
				case let .right((containerArray, index)):
					containerArray[index] = TOMLArray()
					return UEC(containerArray[index].array!, codingPath: self.codingPath, userInfo: self.userInfo)
			}
		} else {
			return UEC(TOMLArray(), codingPath: self.codingPath, userInfo: self.userInfo)
		}
	}

	func singleValueContainer() -> SingleValueEncodingContainer {
		switch self.tomlValueOrArray {
			case let .left(value):
				return SVEC(.left(value), parentKey: self.parentKey!, userInfo: self.userInfo)
			case let .right((array, index)):
				return SVEC(.right((array: array, index: index)), parentKey: nil, userInfo: self.userInfo)
		}
	}

	final class SVEC: SingleValueEncodingContainer {
		var codingPath: [CodingKey]

		var userInfo: [CodingUserInfoKey: Any]

		let tomlValueOrArray: Either<TOMLValue, (array: TOMLArray, index: Int)>

		let parentKey: CodingKey?

		init(_ tomlValueOrArray: Either<TOMLValue, (array: TOMLArray, index: Int)>, parentKey: CodingKey?, userInfo: [CodingUserInfoKey: Any] = [:]) {
			self.tomlValueOrArray = tomlValueOrArray
			self.parentKey = parentKey
			self.userInfo = userInfo
			self.codingPath = []
		}
	}

	final class KEC<Key: CodingKey>: KeyedEncodingContainerProtocol {
		var codingPath: [CodingKey]

		var userInfo: [CodingUserInfoKey: Any]

		let tomlValue: TOMLValue

		let parentKey: CodingKey?

		init(_ tomlValue: TOMLValue, parentKey: CodingKey? = nil, codingPath: [CodingKey], userInfo: [CodingUserInfoKey: Any] = [:]) {
			self.tomlValue = tomlValue
			self.parentKey = parentKey
			self.userInfo = userInfo
			self.codingPath = codingPath
		}
	}

	struct UEC: UnkeyedEncodingContainer {
		var codingPath: [CodingKey]
		var userInfo: [CodingUserInfoKey: Any] = [:]

		var count: Int {
			self.tomlArray.count
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
