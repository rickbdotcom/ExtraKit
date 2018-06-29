//
//  Injectable.swift
//  ExtraKit
//
//  Created by rickb on 1/24/18.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

import Foundation

public protocol Injectable {
	associatedtype Container
	typealias ContainerKeyPath = ReferenceWritableKeyPath<Container, Self?> 

	static var containerKeyPath: ContainerKeyPath { get }
}

public extension NSObject {
	
	func injectableValue<T: Injectable>() -> T? {
		return (self as? T.Container)?[keyPath: T.containerKeyPath]
	}

	@discardableResult func inject<T: Injectable>(value: T?) -> Self {
		(self as? T.Container)?[keyPath: T.containerKeyPath] = value
		return self
	}

	@discardableResult func inject<T, U>(value: T?, keyPath: ReferenceWritableKeyPath<U, T?>) -> Self {
		(self as? U)?[keyPath: keyPath] = value
		return self
	}
}

public protocol NonNilInjectable {
	associatedtype NonNilContainer
	typealias NonNilContainerKeyPath = ReferenceWritableKeyPath<NonNilContainer, Self> 

	static var nonNilContainerKeyPath: NonNilContainerKeyPath { get }
}

public extension NSObject {

	func injectableValue<T: NonNilInjectable>() -> T? {
		return (self as? T.NonNilContainer)?[keyPath: T.nonNilContainerKeyPath]
	}

	@discardableResult func inject<T: NonNilInjectable>(value: T) -> Self {
		(self as? T.NonNilContainer)?[keyPath: T.nonNilContainerKeyPath] = value
		return self
	}

	@discardableResult func inject<T, U>(value: T, keyPath: ReferenceWritableKeyPath<U, T>) -> Self {
		(self as? U)?[keyPath: keyPath] = value
		return self
	}
}

