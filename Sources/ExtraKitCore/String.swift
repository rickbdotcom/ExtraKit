//
//  String.swift
//  ExtraKit
//
//  Created by rickb on 4/18/16.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

import Foundation

public extension String {

    var emptyNil: String? {
        return isEmpty ? nil : self
    }
}

public extension Sequence where Element == String {

    func emptyJoined(separator: String) -> String {
        return map { $0.emptyNil }.emptyJoined(separator: separator)
    }

    func emptyJoined(separator: String) -> String? {
        return emptyJoined(separator: separator).emptyNil
    }
}

public extension Sequence where Element == String? {

    func emptyJoined(separator: String) -> String {
        return compactMap { $0 }.joined(separator: separator)
    }

    func emptyJoined(separator: String) -> String? {
        return emptyJoined(separator: separator).emptyNil
    }
}

public extension Optional where Wrapped == String {

    var isEmpty: Bool {
        return (self ?? "").isEmpty
    }
}
