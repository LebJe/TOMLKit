// Copyright (c) 2021 Jeff Lebrun
//
//  Licensed under the MIT License.
//
//  The full text of the license can be found in the file named LICENSE.

import CTOML

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

import struct Foundation.Calendar
import struct Foundation.Date
import struct Foundation.DateComponents

/// A date in a TOML document.
public struct TOMLDate: Codable, CustomDebugStringConvertible, TOMLValueConvertible, Equatable {
	public let year: Int
	public let month: Int
	public let day: Int

	public var type: TOMLType { .date }
	var cTOMLDate: CTOMLDate {
		CTOMLDate(year: UInt16(self.year), month: UInt8(self.month), day: UInt8(self.day))
	}

	public var debugDescription: String {
		"\(self.year)-\(String(self.month).leftPadding(to: 2))-\(String(self.day).leftPadding(to: 2))"
	}

	public init(year: Int, month: Int, day: Int) {
		self.year = year
		self.month = month
		self.day = day
	}

	public init(date: Date) {
		let calendar = Calendar.current
		let c = calendar.dateComponents([.year, .month, .day], from: date)
		self.year = c.year!
		self.month = c.month!
		self.day = c.day!
	}

	init(cTOMLDate: CTOMLDate) {
		self.year = Int(cTOMLDate.year)
		self.month = Int(cTOMLDate.month)
		self.day = Int(cTOMLDate.day)
	}

	public var date: Date {
		let calendar = Calendar.current
		let dateComponents = DateComponents(
			calendar: calendar,
			year: self.year,
			month: self.month,
			day: self.day
		)

		return calendar.date(from: dateComponents)!
	}

	public func insertIntoTable(tablePointer: OpaquePointer, key: String) {
		tableInsertDate(tablePointer, strdup(key), self.cTOMLDate)
	}

	public func insertIntoArray(arrayPointer: OpaquePointer, index: Int) {
		arrayInsertDate(arrayPointer, Int64(index), self.cTOMLDate)
	}

	public static func == (lhs: TOMLDate, rhs: TOMLDate) -> Bool {
		lhs.year == rhs.year &&
			lhs.month == rhs.month &&
			lhs.day == rhs.day
	}
}

/// A time in a TOML document.
public struct TOMLTime: Codable, CustomDebugStringConvertible, TOMLValueConvertible, Equatable {
	public let hour: Int
	public let minute: Int
	public let second: Int
	public let nanoSecond: Int

	public var type: TOMLType { .time }

	var cTOMLTime: CTOMLTime {
		CTOMLTime(
			hour: UInt8(self.hour),
			minute: UInt8(self.minute),
			second: UInt8(self.second),
			nanoSecond: UInt32(self.nanoSecond)
		)
	}

	public var debugDescription: String {
		"\(String(self.hour).leftPadding(to: 2)):\(String(self.minute).leftPadding(to: 2)):\(String(self.second).leftPadding(to: 2)).\(String(self.nanoSecond).leftPadding(to: 9))Z"
	}

	public init(hour: Int, minute: Int, second: Int, nanoSecond: Int) {
		self.hour = hour
		self.minute = minute
		self.second = second
		self.nanoSecond = nanoSecond
	}

	init(cTOMLTime: CTOMLTime) {
		self.hour = Int(cTOMLTime.hour)
		self.minute = Int(cTOMLTime.minute)
		self.second = Int(cTOMLTime.second)
		self.nanoSecond = Int(cTOMLTime.nanoSecond)
	}

	public func insertIntoTable(tablePointer: OpaquePointer, key: String) {
		tableInsertTime(tablePointer, strdup(key), self.cTOMLTime)
	}

	public func insertIntoArray(arrayPointer: OpaquePointer, index: Int) {
		arrayInsertTime(arrayPointer, Int64(index), self.cTOMLTime)
	}

	public static func == (lhs: TOMLTime, rhs: TOMLTime) -> Bool {
		lhs.hour == rhs.hour &&
			lhs.minute == rhs.minute &&
			lhs.second == rhs.second &&
			lhs.nanoSecond == rhs.nanoSecond
	}
}

/// A date and time in a TOML document.
public struct TOMLTimeOffset: Codable, Equatable {
	public let offset: Int

	var cTOMLTimeOffset: CTOMLTimeOffset {
		CTOMLTimeOffset(minutes: Int16(self.offset))
	}

	public init(offset: Int) {
		self.offset = offset
	}

	init(cTOMLTimeOffset: CTOMLTimeOffset) {
		self.offset = Int(cTOMLTimeOffset.minutes)
	}
}

public struct TOMLDateTime: Codable, CustomDebugStringConvertible, TOMLValueConvertible, Equatable {
	public let date: TOMLDate
	public let time: TOMLTime
	public internal(set) var offset: TOMLTimeOffset?

	var cTOMLDateTime: CTOMLDateTime {
		var offsetPointer: UnsafeMutablePointer<CTOMLTimeOffset>?

		if let o = offset {
			offsetPointer = .allocate(capacity: 1)
			offsetPointer!.pointee = o.cTOMLTimeOffset
		}

		return CTOMLDateTime(date: self.date.cTOMLDate, time: self.time.cTOMLTime, offset: offsetPointer)
	}

	public var debugDescription: String {
		"\(self.date.debugDescription)T\(self.time.debugDescription)"
	}

	public var type: TOMLType { .dateTime }

	/// Creates a `Foundation.Date` from `self`.
	public var fDate: Date {
		let calendar = Calendar.current
		let dateComponents = DateComponents(
			calendar: calendar,
			year: self.date.year,
			month: self.date.month,
			day: self.date.day,
			hour: self.time.hour,
			minute: self.time.minute,
			second: self.time.second,
			nanosecond: self.time.nanoSecond
		)

		return calendar.date(from: dateComponents)!
	}

	init(cTOMLDateTime: CTOMLDateTime) {
		self.date = TOMLDate(cTOMLDate: cTOMLDateTime.date)
		self.time = TOMLTime(cTOMLTime: cTOMLDateTime.time)
		if let off = cTOMLDateTime.offset {
			self.offset = TOMLTimeOffset(cTOMLTimeOffset: off.pointee)
		}
	}

	public init(date: Date) {
		let calendar = Calendar.current
		let c = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: date)
		self.date = TOMLDate(date: date)
		self.time = TOMLTime(hour: c.hour!, minute: c.minute!, second: c.second!, nanoSecond: c.nanosecond!)
	}

	public init(date: TOMLDate, time: TOMLTime, offset: TOMLTimeOffset? = nil) {
		self.date = date
		self.time = time
		self.offset = offset
	}

	public func insertIntoTable(tablePointer: OpaquePointer, key: String) {
		tableInsertDateTime(tablePointer, strdup(key), self.cTOMLDateTime)
	}

	public func insertIntoArray(arrayPointer: OpaquePointer, index: Int) {
		arrayInsertDateTime(arrayPointer, Int64(index), self.cTOMLDateTime)
	}

	public static func == (lhs: TOMLDateTime, rhs: TOMLDateTime) -> Bool {
		lhs.date == rhs.date &&
			lhs.time == rhs.time &&
			lhs.offset == rhs.offset
	}
}
