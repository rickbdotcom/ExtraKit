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
		(self as? T.Container)?[keyPath: T.containerKeyPath] = containable
		return self
	}

	@discardableResult func inject<T, U>(object: T?, keyPath: ReferenceWritableKeyPath<U, T?>) -> Self {
		(self as? U)?[keyPath: keyPath] = object
		return self
	}
}

