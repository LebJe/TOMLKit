// Copyright (c) 2021 Jeff Lebrun
//
//  Licensed under the MIT License.
//
//  The full text of the license can be found in the file named LICENSE.

extension InternalTOMLEncoder.KEC {
	func setupTable() {
		if let parentKey = self.parentKey {
			if self.tomlValue.table?[parentKey.stringValue]?.table == nil {
				self.tomlValue.table?[parentKey.stringValue] = TOMLTable()
			}
		}
	}

	func encodeNil(forKey key: Key) throws {}

	func encode(_ value: Bool, forKey key: Key) throws {
		self.setupTable()
		if let parentKey = self.parentKey {
			self.tomlValue.table?[parentKey.stringValue]?.table?[key.stringValue] = value
		} else {
			self.tomlValue.table?[key.stringValue] = value
		}
	}

	func encode(_ value: String, forKey key: Key) throws {
		self.setupTable()
		if let parentKey = self.parentKey {
			self.tomlValue.table?[parentKey.stringValue]?.table?[key.stringValue] = value
		} else {
			self.tomlValue.table?[key.stringValue] = value
		}
	}

	func encode(_ value: Double, forKey key: Key) throws {
		self.setupTable()
		if let parentKey = self.parentKey {
			self.tomlValue.table?[parentKey.stringValue]?.table?[key.stringValue] = value
		} else {
			self.tomlValue.table?[key.stringValue] = value
		}
	}

	func encode(_ value: Float, forKey key: Key) throws {
		self.setupTable()
		if let parentKey = self.parentKey {
			self.tomlValue.table?[parentKey.stringValue]?.table?[key.stringValue] = Double(value)
		} else {
			self.tomlValue.table?[key.stringValue] = Double(value)
		}
	}

	func encode(_ value: Int, forKey key: Key) throws {
		self.setupTable()
		if let parentKey = self.parentKey {
			self.tomlValue.table?[parentKey.stringValue]?.table?[key.stringValue] = value.tomlInt
		} else {
			self.tomlValue.table?[key.stringValue] = value.tomlInt
		}
	}

	func encode(_ value: Int8, forKey key: Key) throws {
		self.setupTable()
		if let parentKey = self.parentKey {
			self.tomlValue.table?[parentKey.stringValue]?.table?[key.stringValue] = value.tomlInt
		} else {
			self.tomlValue.table?[key.stringValue] = value.tomlInt
		}
	}

	func encode(_ value: Int16, forKey key: Key) throws {
		self.setupTable()
		if let parentKey = self.parentKey {
			self.tomlValue.table?[parentKey.stringValue]?.table?[key.stringValue] = value.tomlInt
		} else {
			self.tomlValue.table?[key.stringValue] = value.tomlInt
		}
	}

	func encode(_ value: Int32, forKey key: Key) throws {
		self.setupTable()
		if let parentKey = self.parentKey {
			self.tomlValue.table?[parentKey.stringValue]?.table?[key.stringValue] = value.tomlInt
		} else {
			self.tomlValue.table?[key.stringValue] = value.tomlInt
		}
	}

	func encode(_ value: Int64, forKey key: Key) throws {
		self.setupTable()
		if let parentKey = self.parentKey {
			self.tomlValue.table?[parentKey.stringValue]?.table?[key.stringValue] = value.tomlInt
		} else {
			self.tomlValue.table?[key.stringValue] = value.tomlInt
		}
	}

	func encode(_ value: UInt, forKey key: Key) throws {
		self.setupTable()
		if let parentKey = self.parentKey {
			self.tomlValue.table?[parentKey.stringValue]?.table?[key.stringValue] = value.tomlInt
		} else {
			self.tomlValue.table?[key.stringValue] = value.tomlInt
		}
	}

	func encode(_ value: UInt8, forKey key: Key) throws {
		self.setupTable()
		if let parentKey = self.parentKey {
			self.tomlValue.table?[parentKey.stringValue]?.table?[key.stringValue] = value.tomlInt
		} else {
			self.tomlValue.table?[key.stringValue] = value.tomlInt
		}
	}

	func encode(_ value: UInt16, forKey key: Key) throws {
		self.setupTable()
		if let parentKey = self.parentKey {
			self.tomlValue.table?[parentKey.stringValue]?.table?[key.stringValue] = value.tomlInt
		} else {
			self.tomlValue.table?[key.stringValue] = value.tomlInt
		}
	}

	func encode(_ value: UInt32, forKey key: Key) throws {
		if let parentKey = self.parentKey {
			self.tomlValue.table?[parentKey.stringValue]?.table?[key.stringValue] = value.tomlInt
		} else {
			self.tomlValue.table?[key.stringValue] = value.tomlInt
		}
	}

	func encode(_ value: UInt64, forKey key: Key) throws {
		self.setupTable()
		if let parentKey = self.parentKey {
			self.tomlValue.table?[parentKey.stringValue]?.table?[key.stringValue] = value.tomlInt
		} else {
			self.tomlValue.table?[key.stringValue] = value.tomlInt
		}
	}

	func encode<T>(_ value: T, forKey key: Key) throws where T: Encodable {
		switch value {
			case is TOMLTime:
				self.setupTable()
				if let parentKey = self.parentKey {
					self.tomlValue.table?[parentKey.stringValue]?.table?[key.stringValue] = value as! TOMLTime
				} else {
					self.tomlValue.table?[key.stringValue] = value as! TOMLTime
				}
			case is TOMLDate:
				self.setupTable()
				if let parentKey = self.parentKey {
					self.tomlValue.table?[parentKey.stringValue]?.table?[key.stringValue] = value as! TOMLDate
				} else {
					self.tomlValue.table?[key.stringValue] = value as! TOMLDate
				}
			case is TOMLDateTime:
				self.setupTable()
				if let parentKey = self.parentKey {
					self.tomlValue.table?[parentKey.stringValue]?.table?[key.stringValue] = value as! TOMLDateTime
				} else {
					self.tomlValue.table?[key.stringValue] = value as! TOMLDateTime
				}
			case is TOMLTable:
				self.setupTable()
				if let parentKey = self.parentKey {
					self.tomlValue.table?[parentKey.stringValue]?.table?[key.stringValue] = value as! TOMLTable
				} else {
					self.tomlValue.table?[key.stringValue] = value as! TOMLTable
				}
			case is TOMLArray:
				self.setupTable()
				if let parentKey = self.parentKey {
					self.tomlValue.table?[parentKey.stringValue]?.table?[key.stringValue] = value as! TOMLArray
				} else {
					self.tomlValue.table?[key.stringValue] = value as! TOMLArray
				}
			case is TOMLInt:
				self.setupTable()
				if let parentKey = self.parentKey {
					self.tomlValue.table?[parentKey.stringValue]?.table?[key.stringValue] = value as! TOMLInt
				} else {
					self.tomlValue.table?[key.stringValue] = value as! TOMLInt
				}
			default:
				self.setupTable()
				if let parentKey = self.parentKey {
					let encoder = InternalTOMLEncoder(.left(self.tomlValue.table![parentKey.stringValue]!.table!.tomlValue), parentKey: key, codingPath: self.codingPath, userInfo: self.userInfo)
					try value.encode(to: encoder)
				} else {
					let encoder = InternalTOMLEncoder(.left(self.tomlValue), parentKey: key, codingPath: self.codingPath, userInfo: self.userInfo)
					try value.encode(to: encoder)
				}
		}
	}

	func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
		if let parentKey = self.parentKey {
			return KeyedEncodingContainer(InternalTOMLEncoder.KEC<NestedKey>(self.tomlValue.table![parentKey.stringValue]!.table!.tomlValue, parentKey: key, codingPath: self.codingPath, userInfo: self.userInfo))
		} else {
			return KeyedEncodingContainer(InternalTOMLEncoder.KEC<NestedKey>(self.tomlValue, parentKey: key, codingPath: self.codingPath, userInfo: self.userInfo))
		}
	}

	func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
		self.self.setupTable()
		if let parentKey = self.parentKey {
			self.tomlValue.table?[parentKey.stringValue]?.table?[key.stringValue] = TOMLArray()
			return InternalTOMLEncoder.UEC(self.tomlValue.table![parentKey.stringValue]!.table![key.stringValue]!.array!, codingPath: self.codingPath, userInfo: self.userInfo)
		} else {
			self.tomlValue.table?[key.stringValue] = TOMLArray()
			return InternalTOMLEncoder.UEC(self.tomlValue.table![key.stringValue]!.array!, codingPath: self.codingPath, userInfo: self.userInfo)
		}
	}

	func superEncoder() -> Encoder {
		fatalError()
	}

	func superEncoder(forKey key: Key) -> Encoder {
		fatalError()
	}
}
