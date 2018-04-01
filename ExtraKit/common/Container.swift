//
//  Container.swift
//  ExtraKit
//
//  Created by rickb on 1/24/18.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

import Foundation

public protocol ContainableObject {
	associatedtype Container

	static var containerKeyPath: ReferenceWritableKeyPath<Container, Self?> { get }
}

public extension NSObject {

	@discardableResult func inject<T: ContainableObject>(containable: T?) -> Self {
		(self as? T.Container)?[keyPath: T.containerKeyPath] = containable as? T
		return self
	}
}

