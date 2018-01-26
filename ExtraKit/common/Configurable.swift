//
//  Configurable.swift
//  ExtraKit
//
//  Created by rickb on 4/18/16.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

import ObjectiveC

public protocol Configurable {
}

public extension Configurable where Self: AnyObject {

    @discardableResult public func configure(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

public extension NSObjectProtocol {

	@discardableResult func configure(_ block: (Self)->Void) -> Self {
		block(self)
		return self
	}
}
