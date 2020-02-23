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
        isEmpty ? nil : self
    }
}

public extension Sequence where Element == String {

    func emptyJoined(separator: String) -> String {
        map { $0.emptyNil }.emptyJoined(separator: separator)
    }

    func emptyJoined(separator: String) -> String? {
        emptyJoined(separator: separator).emptyNil
    }
}

public extension Sequence where Element == String? {

    func emptyJoined(separator: String) -> String {
        compactMap { $0 }.joined(separator: separator)
    }

    func emptyJoined(separator: String) -> String? {
        emptyJoined(separator: separator).emptyNil
    }
}

public extension Optional where Wrapped == String {

    var isEmpty: Bool {
        (self ?? "").isEmpty
    }
}
