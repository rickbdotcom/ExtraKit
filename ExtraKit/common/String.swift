//
//  String.swift
//  ExtraKit
//
//  Created by rickb on 4/18/16.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

import Foundation

public extension Optional where Wrapped == String {

    var isEmptyOrNil: Bool {
        return (self ?? "").isEmpty
    }

    var isEmptyOrNilOrSpaces: Bool {
        return isEmptyOrNil || (self?.isOnlySpaces ?? false)
    }
}

public extension String {

	var isOnlySpaces: Bool {
		return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
	}

	var emptyNil: String? {
		return isEmpty ? nil : self
	}

	var emptyNilSpace: String? {
		return isEmpty || isOnlySpaces ? nil : self
	}
}

public extension Sequence where Iterator.Element == String {

    public func joinedEmptyNilSpace(separator: String = "") -> String {
		return compactMap { $0.emptyNilSpace }.joined(separator: separator)
	}
}
