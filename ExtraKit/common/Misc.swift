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
