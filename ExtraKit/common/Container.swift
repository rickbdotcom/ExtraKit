//
//  Container.swift
//  ExtraKit
//
//  Created by rickb on 1/24/18.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

import UIKit

protocol ContainableObject: class {
	associatedtype Container
	associatedtype Value
	static var containerKeyPath: ReferenceWritableKeyPath<Container, Value?> { get }
}

extension NSObject {
	@discardableResult func inject<T: ContainableObject>(containable: T?) -> Self {
		(self as? T.Container)?[keyPath: T.containerKeyPath] = containable as? T.Value
		return self
	}
}

