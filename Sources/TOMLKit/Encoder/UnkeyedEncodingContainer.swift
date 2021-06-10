// Copyright (c) 2021 Jeff Lebrun
//
//  Licensed under the MIT License.
//
//  The full text of the license can be found in the file named LICENSE.

extension InternalTOMLEncoder.UEC {
	mutating func encodeNil() throws {}

	mutating func encode(_ value: Bool) throws {
		self.tomlArray[self.currentIndex] = value
		self.currentIndex += 1
	}

	mutating func encode(_ value: String) throws {
		self.tomlArray[self.currentIndex] = value
		self.currentIndex += 1
	}

	mutating func encode(_ value: Double) throws {
		self.tomlArray[self.currentIndex] = value
		self.currentIndex += 1
	}

	mutating func encode(_ value: Float) throws {
		self.tomlArray[self.currentIndex] = Double(value)
		self.currentIndex += 1
	}

	mutating func encode(_ value: Int) throws {
		self.tomlArray[self.currentIndex] = value.tomlInt
		self.currentIndex += 1
	}

	mutating func encode(_ value: Int8) throws {
		self.tomlArray[self.currentIndex] = value.tomlInt
		self.currentIndex += 1
	}

	mutating func encode(_ value: Int16) throws {
		self.tomlArray[self.currentIndex] = value.tomlInt
		self.currentIndex += 1
	}

	mutating func encode(_ value: Int32) throws {
		self.tomlArray[self.currentIndex] = value.tomlInt
		self.currentIndex += 1
	}

	mutating func encode(_ value: Int64) throws {
		self.tomlArray[self.currentIndex] = value.tomlInt
		self.currentIndex += 1
	}

	mutating func encode(_ value: UInt) throws {
		self.tomlArray[self.currentIndex] = value.tomlInt
		self.currentIndex += 1
	}

	mutating func encode(_ value: UInt8) throws {
		self.tomlArray[self.currentIndex] = value.tomlInt
		self.currentIndex += 1
	}

	mutating func encode(_ value: UInt16) throws {
		self.tomlArray[self.currentIndex] = value.tomlInt
		self.currentIndex += 1
	}

	mutating func encode(_ value: UInt32) throws {
		self.tomlArray[self.currentIndex] = value.tomlInt
		self.currentIndex += 1
	}

	mutating func encode(_ value: UInt64) throws {
		self.tomlArray[self.currentIndex] = value.tomlInt
		self.currentIndex += 1
	}

	mutating func encode<T>(_ value: T) throws where T: Encodable {
		switch value {
			case is TOMLTime: self.tomlArray[self.currentIndex] = value as! TOMLTime
			case is TOMLDate: self.tomlArray[self.currentIndex] = value as! TOMLDate
			case is TOMLDateTime: self.tomlArray[self.currentIndex] = value as! TOMLDateTime
			case is TOMLTable: self.tomlArray[self.currentIndex] = value as! TOMLTable
			case is TOMLArray: self.tomlArray[self.currentIndex] = value as! TOMLArray
			case is TOMLInt: self.tomlArray[self.currentIndex] = value as! TOMLInt
			default:
				let encoder = InternalTOMLEncoder(.right((array: self.tomlArray, index: self.currentIndex)), parentKey: nil, codingPath: self.codingPath, userInfo: self.userInfo)

				try value.encode(to: encoder)
		}

		self.currentIndex += 1
	}

	mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
		let table = TOMLTable()
		self.tomlArray[self.currentIndex] = table

		return KeyedEncodingContainer(InternalTOMLEncoder.KEC<NestedKey>(table.tomlValue, codingPath: self.codingPath, userInfo: self.userInfo))
	}

	mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
		self.tomlArray[self.currentIndex] = TOMLArray()
		return InternalTOMLEncoder.UEC(self.tomlArray[self.currentIndex]!.array!, codingPath: self.codingPath, userInfo: self.userInfo)
	}

	mutating func superEncoder() -> Encoder {
		fatalError()
	}
}
