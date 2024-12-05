// Copyright (c) 2024 Jeff Lebrun
//
//  Licensed under the MIT License.
//
//  The full text of the license can be found in the file named LICENSE.

// Uncomment the `CustomDump` dependency in Package.swift, uncomment the following line, and use `XCTAssertNoDifference`
// when
// XCTAssertEqual tells you "<huge TOMLTable> is not equal to <other huge TOMLTable>"
// import CustomDump
import Checkit
import Foundation
@testable import TOMLKit
import XCTest

// MARK: - Codable Structures

enum CodableEnum: String, Codable, Equatable {
	case abc
	case def
	case ghi

	public static func == (lhs: Self, rhs: Self) -> Bool {
		switch (lhs, rhs) {
			case (.abc, .abc): return true
			case (.def, .def): return true
			case (.ghi, .ghi): return true
			default: return false
		}
	}
}

struct CodableStruct: Codable, Equatable {
	var string: String = "Hello, World!"
	var int: Int = 44330
	var double: Double = 439.4904
	var bool: Bool = true
	var e: CodableEnum = .abc

	var b = B()

	struct B: Codable, Equatable {
		var time = TOMLTime(hour: 4, minute: 27, second: 5, nanoSecond: 294)
		var date = TOMLDate(year: 2021, month: 5, day: 20)
		var dateTime = TOMLDateTime(
			date: TOMLDate(year: 2021, month: 5, day: 20),
			time: TOMLTime(hour: 4, minute: 27, second: 5, nanoSecond: 294),
			offset: TOMLTimeOffset(offset: 0)
		)
		var array: [String] = ["String 1", "String 2"]
		var c: [CodableStruct.B.C] = [
			.init(a: "Array of C 1", data: Data([0x63, 0x20])),
			.init(a: "Array of C 2", data: Data([0x62, 0x27])),
		]

		struct C: Codable, Equatable {
			var a: String
			var data: Data
		}
	}
}

let tomlForCodableStruct = """
bool = true
double = 439.4904
e = 'abc'
int = 44330
string = 'Hello, World!'

[b]
array = [ 'String 1', 'String 2' ]
date = 2021-05-20
dateTime = 2021-05-20T04:27:05.000000294Z
time = 04:27:05.000000294

	[[b.c]]
	a = 'Array of C 1'
	data = 'YyA='

	[[b.c]]
	a = 'Array of C 2'
	data = 'Yic='
"""

final class TOMLKitTests: XCTestCase {
	let testTable = [
		"String": "Hello, World!",
		"Int": TOMLInt(0xEA64, options: .formatAsHexadecimal),
		"Double": 50.10475,
		"Bool": false,
		"Array": [
			1,
			"Hello, World!",
			2724.49,
			TOMLInt(0b10101001, options: .formatAsBinary),
			Data(Array(repeating: 0x96, count: 5)),
		] as TOMLArray,
		"Date": TOMLDate(year: 2021, month: 5, day: 20),
		"Time": TOMLTime(hour: 4, minute: 27, second: 5, nanoSecond: 294),
		"DateTime": TOMLDateTime(
			date: TOMLDate(year: 2021, month: 5, day: 20),
			time: TOMLTime(hour: 4, minute: 27, second: 5, nanoSecond: 294)
		),
		"Inline-Table": TOMLTable(
			[
				"String 1": "Hello",
				"Time": TOMLTime(hour: 4, minute: 27, second: 5, nanoSecond: 294),
				"Data": Data(Array(repeating: 0x74, count: 5)),
			],
			inline: true
		),
	] as TOMLTable

	let expectedTOMLForTestTable = """
	Array = [ 1, 'Hello, World!', 2724.4899999999998, 0b10101001, 'lpaWlpY=' ]
	Bool = false
	Date = 2021-05-20
	DateTime = 2021-05-20T04:27:05.000000294Z
	Double = 50.104750000000003
	Inline-Table = { Data = 'dHR0dHQ=', 'String 1' = 'Hello', Time = 04:27:05.000000294 }
	Int = 0xEA64
	String = 'Hello, World!'
	Time = 04:27:05.000000294
	"""

	func testTOMLArray() {
		var arr: TOMLArray = [
			"Hello",
			"World",
			1234567890,
			134509.25043,
			true,
			false,
			["Date": TOMLDate(year: 2021, month: 5, day: 20)],
			[
				2397,
				2592.239,
				true,
				"String",
			] as TOMLArray,
		]

		CollectionChecker.check(arr)

		XCTAssertEqual(arr.count, 8)

		arr.append("Hello")

		XCTAssertEqual(arr.count, 9)

		XCTAssertEqual(arr[8].string!, "Hello")

		arr.remove(at: 0)
		arr.removeSubrange(4..<5)

		XCTAssertEqual(arr[0].string!, "World")

		arr.replaceSubrange(2...4, with: [false, "string", TOMLTime(hour: 4, minute: 27, second: 5, nanoSecond: 294)])

		// Read through nested subscript
		XCTAssertEqual(arr[5][2]!.bool!, true)
		XCTAssertEqual(arr[5][3]!.string!, "String")

		// Write through nested subscript
		arr[5][2] = false
		arr[5][3] = "Different String"

		XCTAssertEqual(
			arr,
			TOMLArray([
				"World",
				1234567890,
				false,
				"string",
				TOMLTime(hour: 4, minute: 27, second: 5, nanoSecond: 294),
				[
					2397,
					2592.239,
					false,
					"Different String",
				] as TOMLArray,
				"Hello",
			])
		)
	}

	func testTOMLTableConversion() throws {
		XCTAssertEqual(self.testTable.convert(), self.expectedTOMLForTestTable)
	}

	func testRetrieveValuesFromTable() throws {
		XCTAssertEqual(self.testTable["String"]!.string!, "Hello, World!")
		XCTAssertEqual(self.testTable["Int"]!.int!, 0xEA64)
		XCTAssertEqual(self.testTable["Double"]!.double!, 50.10475)
		XCTAssertEqual(self.testTable["Bool"]!.bool!, false)
		XCTAssertEqual(self.testTable["Array"]!.array![0].int!, 1)
		XCTAssertEqual(self.testTable["Inline-Table"]!["String 1"]!.string!, "Hello")
	}

	func testModifyTOMLTable() throws {
		// Modify nested array.
		XCTAssertEqual(self.testTable["Array"]!.array![0].int!, 1)
		self.testTable["Array"]?.array?[0] = 10
		XCTAssertEqual(self.testTable["Array"]!.array![0].int!, 10)
		self.testTable["Array"]?.array?[0] = 1
		XCTAssertEqual(self.testTable["Array"]!.array![0].int!, 1)

		// Modify nested table.
		XCTAssertEqual(self.testTable["Inline-Table"]!["String 1"]!.string!, "Hello")
		self.testTable["Inline-Table"]!["String 1"] = "Goodbye"
		XCTAssertEqual(self.testTable["Inline-Table"]!["String 1"]!.string!, "Goodbye")
		self.testTable["Inline-Table"]!["String 1"] = "Hello"
		XCTAssertEqual(self.testTable["Inline-Table"]!["String 1"]!.string!, "Hello")

		// Modify non-nested value.
		self.testTable["Bool"] = true
		XCTAssertEqual(self.testTable["Bool"]!.bool!, true)
		self.testTable["Bool"] = false
		XCTAssertEqual(self.testTable["Bool"]!.bool!, false)

		self.testTable["String"] = "String 1"
		XCTAssertEqual(self.testTable["String"]!.string!, "String 1")
		self.testTable["String"] = "Hello, World!"
		XCTAssertEqual(self.testTable["String"]!.string!, "Hello, World!")
	}

	func testTOMLDecoder() throws {
		// Uncomment the dependency in package.swift, and uncomment this line when
		//  XCTAssertEqual tells you "<huge TOMLTable> is not equal to <other huge TOMLTable>" "<large CodableStruct> is not
		//  equal to <other large CodableStruct>"
		// XCTAssertNoDifference(try TOMLDecoder().decode(CodableStruct.self, from: tomlForCodableStruct), CodableStruct())
		XCTAssertEqual(try TOMLDecoder().decode(CodableStruct.self, from: tomlForCodableStruct), CodableStruct())
	}

	func testTOMLEncoder() throws {
		XCTAssertEqual(
			try TOMLTable(string: TOMLEncoder().encode(CodableStruct())),
			try TOMLTable(string: tomlForCodableStruct)
		)
	}

	func testCustomDataDecodingAndEncoding() throws {
		struct Test: Codable, Equatable {
			let data: Data
		}

		// Encoder

		var encoder = TOMLEncoder()
		encoder.dataEncoder = Array.init

		let data = Data("Hello World!".utf8).base64EncodedData()

		let toml = try encoder.encode(Test(data: data))

		XCTAssertEqual(toml, "data = [ 83, 71, 86, 115, 98, 71, 56, 103, 86, 50, 57, 121, 98, 71, 81, 104 ]")

		// Decoder
		var decoder = TOMLDecoder()

		decoder.dataDecoder = {
			let arr = $0.array!.map({ UInt8($0.int!) })
			return Data(base64Encoded: Data(arr))!
		}

		let test = try decoder.decode(Test.self, from: toml)
		XCTAssertEqual(String(data: test.data, encoding: .utf8)!, "Hello World!")
	}

	func testFailedDecoding() throws {
		let toml1 = """
		  bool = true
		  double = 439.4904
		  e = 'abc'
		  int = 44330
		  string = 'Hello, World!'

		  [b]
		  array = [ 'String 1', 'String 2' ]
		  date = 2021-05-20
		  dateTime = 2021-05-20T04:27:05.000000294Z
		  time = 04:27:05.000000294

			  [[b.c]]
			  #a = 'Array of C 1'
			  data = 'YyA='

			  [[b.c]]
			  a = 'Array of C 2'
			  data = 'Yic='
		"""

		let decoder = TOMLDecoder()

		do {
			_ = try decoder.decode(CodableStruct.self, from: toml1)
		} catch let error as DecodingError {
			switch error {
				case let .keyNotFound(key, context):
					XCTAssertEqual(key.stringValue, "a")
					XCTAssertEqual(context.codingPath.count, 4)
					XCTAssertEqual(context.codingPath[0].stringValue, "b")
					XCTAssertEqual(context.codingPath[1].stringValue, "c")
					XCTAssertEqual(context.codingPath[2].intValue, 0)
					XCTAssertEqual(context.codingPath[3].stringValue, "a")
				default: XCTFail("An error other than \"keyNotFound\" occurred: \(error)")
			}
		} catch {
			XCTFail("An error other than \"DecodingError\" occurred: \(error)")
		}
	}

	func testStrictDecoding() throws {
		let decoder = TOMLDecoder(strictDecoding: true)

		let tomlTableForCodableStruct = try TOMLTable(string: tomlForCodableStruct)

		// Add invalid keys
		tomlTableForCodableStruct["invalidKey1"] = false
		tomlTableForCodableStruct["b"]!["c"]![1]!["invalidKey2"] = "invalid"
		tomlTableForCodableStruct["b"]!["invalidKey3"] = 2352

		XCTAssertThrowsError(try decoder.decode(CodableStruct.self, from: tomlTableForCodableStruct), "", { error in
			guard let error = error as? UnexpectedKeysError else {
				XCTFail("Expected `UnexpectedKeysError`, found \(error)")
				return
			}
			XCTAssertEqual(error.keys.keys.sorted(), ["invalidKey1", "invalidKey2", "invalidKey3"])
			XCTAssertEqual(["invalidKey1"], error.keys["invalidKey1"]?.map(\.stringValue))
			XCTAssertEqual(["b", "c", "Index 1", "invalidKey2"], error.keys["invalidKey2"]?.map(\.stringValue))
			XCTAssertEqual(["b", "invalidKey3"], error.keys["invalidKey3"]?.map(\.stringValue))
		})
	}

	func testMeasureEncoding() {
		self.measure {
			_ = try! TOMLEncoder().encode(CodableStruct())
		}
	}

	func testMeasureDecoding() {
		self.measure {
			_ = try! TOMLDecoder().decode(CodableStruct.self, from: tomlForCodableStruct)
		}
	}

	func testInvalidToml() throws {
		let invalidTOML1 = """
		Array = [
		Bool = flse
		Date = 2021-05-20
		"""

		do {
			_ = try TOMLTable(string: invalidTOML1)
		} catch let error as TOMLParseError {
			XCTAssertEqual(error.source.begin.line, 2)
			XCTAssertEqual(error.source.begin.column, 1)

			XCTAssertEqual(error.source.end.line, 2)
			XCTAssertEqual(error.source.end.column, 1)
		}

		let invalidTOML2 = """
		Double = 50.10475.
		Inline-Table = { "String 1" = 'Hello', Time = 24:59:59.000000294 }
		Int = 60004
		String = 'Hello, World!
		"""

		do {
			_ = try TOMLTable(string: invalidTOML2)
		} catch let error as TOMLParseError {
			XCTAssertEqual(error.source.begin.line, 1)
			XCTAssertEqual(error.source.begin.column, 18)

			XCTAssertEqual(error.source.end.line, 1)
			XCTAssertEqual(error.source.end.column, 18)
		}

		let invalidTOML3 = """
		String = 'Hello, World!
		"""

		do {
			_ = try TOMLTable(string: invalidTOML3)
		} catch let error as TOMLParseError {
			XCTAssertEqual(error.source.begin.line, 1)
			XCTAssertEqual(error.source.begin.column, 24)

			XCTAssertEqual(error.source.end.line, 1)
			XCTAssertEqual(error.source.end.column, 24)
		}
	}

	func testParseValidTOML() throws {
		// Test `TOMLTable`'s `Equatable` conformance.
		XCTAssert(try TOMLTable(string: self.expectedTOMLForTestTable) == self.testTable)
	}

	func testYAMLConversion() throws {
		let expectedYAML = """
		Array: 
		  - 1
		  - 'Hello, World!'
		  - 2724.4899999999998
		  - 0b10101001
		  - 'lpaWlpY='
		Bool: false
		Date: '2021-05-20'
		DateTime: '2021-05-20T04:27:05.000000294Z'
		Double: 50.104750000000003
		Inline-Table: 
		  Data: 'dHR0dHQ='
		  'String 1': Hello
		  Time: '04:27:05.000000294'
		Int: 0xEA64
		String: 'Hello, World!'
		Time: '04:27:05.000000294'
		"""

		XCTAssertEqual(self.testTable.convert(to: .yaml), expectedYAML)
	}

	// https://github.com/LebJe/TOMLKit/issues/12
	func testIssue12() throws {
		let string = "[[apps.test]]"

		struct Child: Codable {
			var value: String // if Child is an empty struct it doesn't crash
		}

		struct Parent: Codable {
			var apps: [String: Child] // if this is just `[String: String]` it doesn't crash
		}

		do {
			_ = try TOMLDecoder().decode(Parent.self, from: string)
		} catch let error as DecodingError {
			switch error {
				case let .typeMismatch(type, context):
					XCTAssert(type == TOMLTable.self)
					XCTAssertEqual(context.debugDescription, "Expected a table, but found a array instead.")
				default: XCTFail("DecodingError.typeMismatch was not thrown: \(error)")
			}
		} catch {
			XCTFail("DecodingError did not occur.")
		}
	}
	
	func testFailingToDecodingDateFromUDCShouldNotIncreaseIndex() throws {
		let udc = InternalTOMLDecoder.UDC(
			["Not a date"],
			codingPath: [],
			userInfo: [:],
			dataDecoder: { $0.string != nil ? Data(base64Encoded: $0.string!) : nil },
			strictDecoding: false,
			notDecodedKeys: InternalTOMLDecoder.NotDecodedKeys()
		)
		
		XCTAssertThrowsError(try udc.decode(Date.self))
		XCTAssertEqual(udc.currentIndex, 0)
	}
	
	func testDecodingObjectFromUDCShouldIncreaseIndex() throws {
		struct StringCodingKey: CodingKey, Equatable {
			var stringValue: String
			
			init(stringValue: String) {
				self.stringValue = stringValue
			}
			
			var intValue: Int? { nil }
			init?(intValue: Int) { nil }
		}
		
		
		let udc = InternalTOMLDecoder.UDC(
			[TOMLTable(["key": "value"], inline: false)],
			codingPath: [],
			userInfo: [:],
			dataDecoder: { $0.string != nil ? Data(base64Encoded: $0.string!) : nil },
			strictDecoding: false,
			notDecodedKeys: InternalTOMLDecoder.NotDecodedKeys()
		)
		
		let _ = try udc.nestedContainer(keyedBy: StringCodingKey.self)
		XCTAssertEqual(udc.currentIndex, 1)
	}
	
	func testDecodingArrayFromUDCShouldIncreaseIndex() throws {
		let udc = InternalTOMLDecoder.UDC(
			[["value"]],
			codingPath: [],
			userInfo: [:],
			dataDecoder: { $0.string != nil ? Data(base64Encoded: $0.string!) : nil },
			strictDecoding: false,
			notDecodedKeys: InternalTOMLDecoder.NotDecodedKeys()
		)
		
		let _ = try udc.nestedUnkeyedContainer()
		XCTAssertEqual(udc.currentIndex, 1)
	}
}
