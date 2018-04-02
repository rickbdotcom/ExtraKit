//
//  Container.swift
//  ExtraKit
//
//  Created by rickb on 1/24/18.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

import Foundation

public protocol Containable {
	associatedtype Container
	typealias ContainerKeyPath = ReferenceWritableKeyPath<Container, Self?> 

	static var containerKeyPath: ContainerKeyPath { get }
}

public extension NSObject {

	@discardableResult func inject<T: Containable>(value: T?) -> Self {
		(self as? T.Container)?[keyPath: T.containerKeyPath] = value
		return self
	}

	@discardableResult func inject<T, U>(value: T?, keyPath: ReferenceWritableKeyPath<U, T?>) -> Self {
		(self as? U)?[keyPath: keyPath] = value
		return self
	}
}

