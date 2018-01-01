import Foundation

public extension NSObject {

	class func swizzle(instanceMethod originalSelector: Selector, with newSelector: Selector) {
		swizzle(self
		, 	(originalSelector, class_getInstanceMethod(self, originalSelector))
		,	(newSelector, class_getInstanceMethod(self, newSelector))
		)
	}
		
	class func swizzle(classMethod originalSelector: Selector, with newSelector: Selector) {
		let c: AnyClass = object_getClass(self)!
		swizzle(c
		,	(originalSelector, class_getClassMethod(c, originalSelector))
		,	(newSelector, class_getClassMethod(c, newSelector))
		)
	}

	class func swizzle(_ c: AnyClass, _ original: (Selector, Method?), _ new: (Selector, Method?)) {
		guard let originalMethod = original.1, let newMethod = new.1 else {
			return
		}
		if class_addMethod(c, original.0, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)) {
			class_replaceMethod(c, new.0, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
		} else {
			method_exchangeImplementations(originalMethod, newMethod)
		}
	}
}
