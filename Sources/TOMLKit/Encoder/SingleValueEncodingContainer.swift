// Copyright (c) 2021 Jeff Lebrun
//
//  Licensed under the MIT License.
//
//  The full text of the license can be found in the file named LICENSE.

extension InternalTOMLEncoder.SVEC {
	func encodeNil() throws {}

	func encode(_ value: Bool) throws {
		switch self.tomlValueOrArray {
			case let .left(t):
				t.table?[self.parentKey!.stringValue] = value
			case let .right((array, index)):
				array[index] = value
		}
	}

	func encode(_ value: String) throws {
		switch self.tomlValueOrArray {
			case let .left(t):
				t.table?[self.parentKey!.stringValue] = value
			case let .right((array, index)):
				array[index] = value
		}
	}

	func encode(_ value: Double) throws {
		switch self.tomlValueOrArray {
			case let .left(t):
				t.table?[self.parentKey!.stringValue] = value
			case let .right((array, index)):
				array[index] = value
		}
	}

	func encode(_ value: Float) throws {
		switch self.tomlValueOrArray {
			case let .left(t):
				t.table?[self.parentKey!.stringValue] = Double(value)
			case let .right((array, index)):
				array[index] = Double(value)
		}
	}

	func encode(_ value: Int) throws {
		switch self.tomlValueOrArray {
			case let .left(t):
				t.table?[self.parentKey!.stringValue] = value.tomlInt
			case let .right((array, index)):
				array[index] = value.tomlInt
		}
	}

	func encode(_ value: Int8) throws {
		switch self.tomlValueOrArray {
			case let .left(t):
				t.table?[self.parentKey!.stringValue] = value.tomlInt
			case let .right((array, index)):
				array[index] = value.tomlInt
		}
	}

	func encode(_ value: Int16) throws {
		switch self.tomlValueOrArray {
			case let .left(t):
				t.table?[self.parentKey!.stringValue] = value.tomlInt
			case let .right((array, index)):
				array[index] = value.tomlInt
		}
	}

	func encode(_ value: Int32) throws {
		switch self.tomlValueOrArray {
			case let .left(t):
				t.table?[self.parentKey!.stringValue] = value.tomlInt
			case let .right((array, index)):
				array[index] = value.tomlInt
		}
	}

	func encode(_ value: Int64) throws {
		switch self.tomlValueOrArray {
			case let .left(t):
				t.table?[self.parentKey!.stringValue] = value.tomlInt
			case let .right((array, index)):
				array[index] = value.tomlInt
		}
	}

	func encode(_ value: UInt) throws {
		switch self.tomlValueOrArray {
			case let .left(t):
				t.table?[self.parentKey!.stringValue] = value.tomlInt
			case let .right((array, index)):
				array[index] = value.tomlInt
		}
	}

	func encode(_ value: UInt8) throws {
		switch self.tomlValueOrArray {
			case let .left(t):
				t.table?[self.parentKey!.stringValue] = value.tomlInt
			case let .right((array, index)):
				array[index] = value.tomlInt
		}
	}

	func encode(_ value: UInt16) throws {
		switch self.tomlValueOrArray {
			case let .left(t):
				t.table?[self.parentKey!.stringValue] = value.tomlInt
			case let .right((array, index)):
				array[index] = value.tomlInt
		}
	}

	func encode(_ value: UInt32) throws {
		switch self.tomlValueOrArray {
			case let .left(t):
				t.table?[self.parentKey!.stringValue] = value.tomlInt
			case let .right((array, index)):
				array[index] = value.tomlInt
		}
	}

	func encode(_ value: UInt64) throws {
		switch self.tomlValueOrArray {
			case let .left(t):
				t.table?[self.parentKey!.stringValue] = value.tomlInt
			case let .right((array, index)):
				array[index] = value.tomlInt
		}
	}

	func encode<T>(_ value: T) throws where T: Encodable {
		switch value {
			case is TOMLTime:
				switch self.tomlValueOrArray {
					case let .left(t):
						t.table?[self.parentKey!.stringValue] = value as! TOMLTime
					case let .right((array, index)):
						array[index] = value as! TOMLTime
				}
			case is TOMLDate:
				switch self.tomlValueOrArray {
					case let .left(t):
						t.table?[self.parentKey!.stringValue] = value as! TOMLDate
					case let .right((array, index)):
						array[index] = value as! TOMLDate
				}
			case is TOMLDateTime:
				switch self.tomlValueOrArray {
					case let .left(t):
						t.table?[self.parentKey!.stringValue] = value as! TOMLDateTime
					case let .right((array, index)):
						array[index] = value as! TOMLDateTime
				}
			case is TOMLTable:
				switch self.tomlValueOrArray {
					case let .left(t):
						t.table?[self.parentKey!.stringValue] = value as! TOMLTable
					case let .right((array, index)):
						array[index] = value as! TOMLTable
				}
			case is TOMLArray:
				switch self.tomlValueOrArray {
					case let .left(t):
						t.table?[self.parentKey!.stringValue] = value as! TOMLArray
					case let .right((array, index)):
						array[index] = value as! TOMLArray
				}
			case is TOMLInt:
				switch self.tomlValueOrArray {
					case let .left(t):
						t.table?[self.parentKey!.stringValue] = value as! TOMLInt
					case let .right((array, index)):
						array[index] = value as! TOMLInt
				}
			default:
				switch self.tomlValueOrArray {
					case let .left(t):
						let encoder = InternalTOMLEncoder(.left(t.tomlValue), parentKey: self.parentKey, codingPath: self.codingPath, userInfo: self.userInfo)
						try value.encode(to: encoder)
					case let .right((array, index)):
						let encoder = InternalTOMLEncoder(.right((array: array, index: index)), parentKey: self.parentKey, codingPath: self.codingPath, userInfo: self.userInfo)
						try value.encode(to: encoder)
				}
		}
	}
}
