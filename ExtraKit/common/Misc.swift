//
//  Misc.swift
//  ExtraKit
//
//  Created by rickb on 4/18/16.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

public protocol EnumCollection: Hashable {

    static func cases() -> AnySequence<Self>
    static var all: [Self] { get }
}

public extension EnumCollection {
    
    public static func cases() -> AnySequence<Self> {
        return AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            return AnyIterator {
                let current: Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: self, capacity: 1) { $0.pointee } }
                guard current.hashValue == raw else {
                    return nil
                }
                raw += 1
                return current
            }
        }
    }
    
    public static var all: [Self] {
        return Array(self.cases())
    }
}

public extension Array {

	func randomElement() -> Element {
		return self[Int(arc4random_uniform(UInt32(count)))]
	}
}

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

// Swift 4.3
public extension Bool {
	mutating func toggle() {
    	self = !self
  	}
}
