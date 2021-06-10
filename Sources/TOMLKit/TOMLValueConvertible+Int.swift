// Copyright (c) 2021 Jeff Lebrun
//
//  Licensed under the MIT License.
//
//  The full text of the license can be found in the file named LICENSE.

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
	import Darwin.C
#elseif os(Linux) || os(Android)
	import Glibc
#elseif os(Windows)
	// TODO: is this the right module?
	import ucrt
#else
	#error("Unsupported Platform")
#endif

import CTOML

// extension Int8: TOMLValueConvertible {
//	public var type: TOMLType { .int }
//
//	public func insertIntoTable(tablePointer: OpaquePointer, key: String) {
//		tableInsertInt(tablePointer, strdup(key), Int64(self))
//	}
//
//	public func insertIntoArray(arrayPointer: OpaquePointer, index: Int) {
//		arrayInsertInt(arrayPointer, Int64(index), Int64(self))
//	}
// }
//
// extension Int16: TOMLValueConvertible {
//	public var type: TOMLType { .int }
//
//	public func insertIntoTable(tablePointer: OpaquePointer, key: String) {
//		tableInsertInt(tablePointer, strdup(key), Int64(self))
//	}
//
//	public func insertIntoArray(arrayPointer: OpaquePointer, index: Int) {
//		arrayInsertInt(arrayPointer, Int64(index), Int64(self))
//	}
// }
//
// extension Int32: TOMLValueConvertible {
//	public var type: TOMLType { .int }
//
//	public func insertIntoTable(tablePointer: OpaquePointer, key: String) {
//		tableInsertInt(tablePointer, strdup(key), Int64(self))
//	}
//
//	public func insertIntoArray(arrayPointer: OpaquePointer, index: Int) {
//		arrayInsertInt(arrayPointer, Int64(index), Int64(self))
//	}
// }
//
// extension Int: TOMLValueConvertible {
//	public var type: TOMLType { .int }
//
//	public func insertIntoTable(tablePointer: OpaquePointer, key: String) {
//		tableInsertInt(tablePointer, strdup(key), Int64(self))
//	}
//
//	public func insertIntoArray(arrayPointer: OpaquePointer, index: Int) {
//		arrayInsertInt(arrayPointer, Int64(index), Int64(self))
//	}
// }
//
// extension Int64: TOMLValueConvertible {
//	public var type: TOMLType { .int }
//
//	public func insertIntoTable(tablePointer: OpaquePointer, key: String) {
//		tableInsertInt(tablePointer, strdup(key), self)
//	}
//
//	public func insertIntoArray(arrayPointer: OpaquePointer, index: Int) {
//		arrayInsertInt(arrayPointer, Int64(index), self)
//	}
// }
//
// extension UInt8: TOMLValueConvertible {
//	public var type: TOMLType { .int }
//
//	public func insertIntoTable(tablePointer: OpaquePointer, key: String) {
//		tableInsertInt(tablePointer, strdup(key), Int64(self))
//	}
//
//	public func insertIntoArray(arrayPointer: OpaquePointer, index: Int) {
//		arrayInsertInt(arrayPointer, Int64(index), Int64(self))
//	}
// }
//
// extension UInt16: TOMLValueConvertible {
//	public var type: TOMLType { .int }
//
//	public func insertIntoTable(tablePointer: OpaquePointer, key: String) {
//		tableInsertInt(tablePointer, strdup(key), Int64(self))
//	}
//
//	public func insertIntoArray(arrayPointer: OpaquePointer, index: Int) {
//		arrayInsertInt(arrayPointer, Int64(index), Int64(self))
//	}
// }
//
// extension UInt32: TOMLValueConvertible {
//	public var type: TOMLType { .int }
//
//	public func insertIntoTable(tablePointer: OpaquePointer, key: String) {
//		tableInsertInt(tablePointer, strdup(key), Int64(self))
//	}
//
//	public func insertIntoArray(arrayPointer: OpaquePointer, index: Int) {
//		arrayInsertInt(arrayPointer, Int64(index), Int64(self))
//	}
// }
//
// extension UInt: TOMLValueConvertible {
//	public var type: TOMLType { .int }
//
//	public func insertIntoTable(tablePointer: OpaquePointer, key: String) {
//		tableInsertInt(tablePointer, strdup(key), Int64(self))
//	}
//
//	public func insertIntoArray(arrayPointer: OpaquePointer, index: Int) {
//		arrayInsertInt(arrayPointer, Int64(index), Int64(self))
//	}
// }
//
// extension UInt64: TOMLValueConvertible {
//	public var type: TOMLType { .int }
//
//	public func insertIntoTable(tablePointer: OpaquePointer, key: String) {
//		tableInsertInt(tablePointer, strdup(key), Int64(self))
//	}
//
//	public func insertIntoArray(arrayPointer: OpaquePointer, index: Int) {
//		arrayInsertInt(arrayPointer, Int64(index), Int64(self))
//	}
// }
