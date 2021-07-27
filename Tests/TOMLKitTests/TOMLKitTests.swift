// Copyright (c) 2021 Jeff Lebrun
//
//  Licensed under the MIT License.
//
//  The full text of the license can be found in the file named LICENSE.

@testable import TOMLKit
import XCTest

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
	Array = [ 1, 'Hello, World!', 2724.49, 0b10101001, 'lpaWlpY=' ]
	Bool = false
	Date = 2021-05-20
	DateTime = 2021-05-20T04:27:05.000000294Z
	Double = 50.10475
	Inline-Table = { Data = 'dHR0dHQ=', "String 1" = 'Hello', Time = 04:27:05.000000294 }
	Int = 0xEA64
	String = 'Hello, World!'
	Time = 04:27:05.000000294
	"""

	func testTOMLArray() {
		var arr: TOMLArray = ["Hello", "World", 1234567890, 134509.25043, true, false, ["Date": TOMLDate(year: 2021, month: 5, day: 20)] as TOMLTable]

		XCTAssertEqual(arr.count, 7)

		arr.append("Hello")

		XCTAssertEqual(arr.count, 8)

		XCTAssertEqual(arr[7].string!, "Hello")

		arr.remove(at: 0)
		arr.removeSubrange(4..<6)

		XCTAssertEqual(arr[0].string!, "World")

		arr.replaceSubrange(2...4, with: [false, "string", TOMLTime(hour: 4, minute: 27, second: 5, nanoSecond: 294)])

		XCTAssertEqual(arr, TOMLArray(["World", 1234567890, false, "string", TOMLTime(hour: 4, minute: 27, second: 5, nanoSecond: 294)]))
	}

	func testTOMLTable() throws {
		XCTAssertEqual(self.testTable.convert(), self.expectedTOMLForTestTable)
	}

	func testRetrieveValuesFromTable() throws {
		XCTAssertEqual(self.testTable["String"]!.string!, "Hello, World!")
		XCTAssertEqual(self.testTable["Int"]!.int!, 0xEA64)
		XCTAssertEqual(self.testTable["Double"]!.double!, 50.10475)
		XCTAssertEqual(self.testTable["Bool"]!.bool!, false)
		XCTAssertEqual(self.testTable["Array"]!.array![0].int!, 1)
	}

	func testTOMLDecoder() throws {
		let toml = """
		bool = true
		double = 3053.53
		e = 'abc'
		int = 2093
		string = 'Hello, World!'

		[b]
		array = [ 'Hello', 'World!' ]
		date = 2021-05-20
		dateTime = 2021-05-20T04:27:05.000000294Z
		time = 04:27:05.000000294

			[[b.c]]
			a = 'Hello, World!'
			data = 'YyA='

			[[b.c]]
			a = 'Hello'
			data = 'Yic='
		"""

		enum E: String, Codable, Equatable {
			case abc
			case def
			case ghi

			public static func == (lhs: E, rhs: E) -> Bool {
				switch (lhs, rhs) {
					case (.abc, .abc): return true
					case (.def, .def): return true
					case (.ghi, .ghi): return true
					default: return false
				}
			}
		}

		struct A: Decodable, Equatable {
			let string: String
			let int: Int
			let double: Double
			let bool: Bool
			let e: E

			let b: B

			struct B: Decodable, Equatable {
				let time: TOMLTime
				let date: TOMLDate
				let dateTime: TOMLDateTime
				let array: [String]
				let c: [A.B.C]

				struct C: Decodable, Equatable {
					let a: String
					let data: Data
				}
			}
		}

		let a = A(
			string: "Hello, World!",
			int: 2093,
			double: 3053.53,
			bool: true,
			e: .abc,
			b: A.B(
				time: TOMLTime(hour: 4, minute: 27, second: 5, nanoSecond: 294),
				date: TOMLDate(year: 2021, month: 5, day: 20),
				dateTime: TOMLDateTime(
					date: TOMLDate(year: 2021, month: 5, day: 20),
					time: TOMLTime(hour: 4, minute: 27, second: 5, nanoSecond: 294),
					offset: TOMLTimeOffset(offset: 0)
				),
				array: ["Hello", "World!"],
				c: [
					A.B.C(a: "Hello, World!", data: Data([0x63, 0x20])),
					A.B.C(a: "Hello", data: Data([0x62, 0x27])),
				]
			)
		)

		XCTAssertEqual(try TOMLDecoder().decode(A.self, from: toml), a)
	}

	func testTOMLEncoder() throws {
		enum E: String, Codable {
			case abc
			case def
			case ghi
		}

		struct A: Encodable {
			var string: String = "Hello, World!"
			var int: Int = 44330
			var double: Double = 439.4904
			var bool: Bool = true
			var e: E = .abc

			var b = B()

			struct B: Encodable {
				var time = TOMLTime(hour: 4, minute: 27, second: 5, nanoSecond: 294)
				var date = TOMLDate(year: 2021, month: 5, day: 20)
				var dateTime = TOMLDateTime(
					date: TOMLDate(year: 2021, month: 5, day: 20),
					time: TOMLTime(hour: 4, minute: 27, second: 5, nanoSecond: 294)
				)
				var array: [String] = ["String 1", "String 2"]
				var c: [A.B.C] = [
					.init(a: "Array of C 1", data: Data([0x63, 0x20])),
					.init(a: "Array of C 2", data: Data([0x62, 0x27])),
				]

				struct C: Encodable {
					var a: String
					var data: Data
				}
			}
		}

		let toml = """
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

		XCTAssertEqual(try TOMLTable(string: try TOMLEncoder().encode(A())), try TOMLTable(string: toml))
	}

	func testCustomDataDecodingAndEncoding() {
		struct Test: Codable, Equatable {
			let data: Data
		}

		XCTAssertEqual(try TOMLEncoder(dataEncoder: { _ in "Hello" }).encode(Test(data: Data([0x01]))), "data = 'Hello'")

		XCTAssertEqual(try TOMLDecoder(dataDecoder: { _ in Data([0x01]) }).decode(Test.self, from: "data = 'Hello'"), Test(data: Data([0x01])))
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
}
