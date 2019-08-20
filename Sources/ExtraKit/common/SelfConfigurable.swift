//
//  Configurable.swift
//  ExtraKit
//
//  Created by rickb on 4/18/16.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

import ObjectiveC

public protocol SelfConfigurable {
}

public extension SelfConfigurable where Self: AnyObject {

    @discardableResult func configure(_ block: (Self) -> Void) -> Self {
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
