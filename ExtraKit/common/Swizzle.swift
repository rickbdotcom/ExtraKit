//
//  Swizzle.swift
//  ExtraKit
//
//  Created by rickb on 4/18/16.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

import Foundation

public extension NSObject {

	class func swizzle(instanceMethod originalSelector: Selector, with newSelector: Selector) {
		swizzle(self, 
			(originalSelector, class_getInstanceMethod(self, originalSelector)),
			(newSelector, class_getInstanceMethod(self, newSelector))
		)
	}
		
	class func swizzle(classMethod originalSelector: Selector, with newSelector: Selector) {
		let klass: AnyClass = object_getClass(self)!
		swizzle(klass,
			(originalSelector, class_getClassMethod(klass, originalSelector)),
			(newSelector, class_getClassMethod(klass, newSelector))
		)
	}

	class func swizzle(_ klass: AnyClass, _ original: (Selector, Method?), _ new: (Selector, Method?)) {
		guard let originalMethod = original.1, let newMethod = new.1 else {
			return
		}
		if class_addMethod(klass, original.0, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)) {
			class_replaceMethod(klass, new.0, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
		} else {
			method_exchangeImplementations(originalMethod, newMethod)
		}
	}
}
