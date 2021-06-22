//
//  File.swift
//  
//
//  Created by Jeff Lebrun on 6/22/21.
//

public struct TOMLArrayIterator: IteratorProtocol {
	let array: TOMLArray
	var currentIndex = 0

	public mutating func next() -> TOMLValueConvertible? {
		guard self.currentIndex <= self.array.endIndex - 1 else { return nil }
		let element = array[self.currentIndex]
		currentIndex += 1
		return element
	}
}
