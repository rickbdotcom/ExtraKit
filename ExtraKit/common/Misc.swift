//
//  Misc.swift
//  ExtraKit
//
//  Created by rickb on 4/18/16.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

public extension RandomAccessCollection where Self: RangeReplaceableCollection, Self.Index == Int {
	
	func shiftedLeft(by rawOffset: Int = 1) -> SubSequence {
		let clampedAmount = rawOffset % count
		let offset = clampedAmount < 0 ? count + clampedAmount : clampedAmount
		return self[offset ..< count] + self[0 ..< offset]
	}

	func shiftedRight(by rawOffset: Int = 1) -> SubSequence {
		return self.shiftedLeft(by: -rawOffset)
	}

	public  mutating func shiftLeft(by rawOffset: Int = 1) {
		self = Self.init(self.shiftedLeft(by: rawOffset))
	}

	public  mutating func shiftRight(by rawOffset: Int = 1) {
		self = Self.init(self.shiftedRight(by: rawOffset))
	}
}
