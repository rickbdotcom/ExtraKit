import Foundation
import ObjectiveC

private var associatedDictionaryKey = 0

public protocol NoArgInitable {
	init()
}

public extension NSObject {

	var associatedDictionary: NSMutableDictionary {
		get {
			return objc_getAssociatedObject(self, &associatedDictionaryKey) as? NSMutableDictionary
			?? NSMutableDictionary().configure {
				objc_setAssociatedObject(self, &associatedDictionaryKey, $0, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			}
		}
	}

	func getAssociatedValue<T>(module: String? = nil, functionName: String? = #function, _ initialValue: @autoclosure ()-> T) -> T {
		let key = associatedKey(module: module, functionName: functionName)
		if let value: T = associatedValue(forKey: key) {
			return value
		}
		let value = initialValue()
		set(associatedValue: value, forKey: key)
		return value
	}

	func getAssociatedValue<T: NoArgInitable>(module: String? = nil, functionName: String? = #function) -> T {
		let key = associatedKey(module: module, functionName: functionName)
		if let value: T = associatedValue(forKey: key) {
			return value
		}
		let value = T()
		set(associatedValue: value, forKey: key)
		return value
	}

	func associatedKey(module: String? = nil, functionName: String? = #function) -> String {
		return [module ?? Bundle(for: self.classForCoder).bundleIdentifier, functionName].flatMap{$0}.joined(separator: ".")
	}
	
	func associatedValue<T>(module: String? = nil, functionName: String? = #function) -> T? {
		return associatedValue(forKey: associatedKey(module: module, functionName: functionName))
	}

	func set(associatedValue value: Any?, module: String? = nil, functionName: String? = #function) {
		return set(associatedValue: value, forKey: associatedKey(module: module, functionName: functionName))
	}
	
	func weakAssociatedValue<T>(module: String? = nil, functionName: String? = #function) -> T? {
		return weakAssociatedValue(forKey: associatedKey(module: module, functionName: functionName))
	}
	
	func set(weakAssociatedValue value: AnyObject?, module: String? = nil, functionName: String? = #function) {
		set(weakAssociatedValue: value, forKey: associatedKey(module: module, functionName: functionName))
	}

	func associatedValue<T>(forKey key: String) -> T? {
		return associatedDictionary[key] as? T
	}
	
	func set(associatedValue value: Any?, forKey key: String) {
		associatedDictionary[key] = value
	}

	func weakAssociatedValue<T>(forKey key: String) -> T? {
		return (associatedDictionary[key] as? WeakObjectRef)?.object as? T
	}
	
	func set(weakAssociatedValue value: AnyObject?, forKey key: String) {
		associatedDictionary[key] = WeakObjectRef(value)
	}
}

private let associatedValueKey = "com.rickb.extrakit.Observing"

class NotificationObserver {
	
	var observer: Any
	
	init(forName name: NSNotification.Name, object: Any? = nil, queue: OperationQueue? = nil, usingBlock block: @escaping (Notification) -> Void) {
		 observer = NotificationCenter.default.addObserver(forName: name, object: object, queue: queue, using: block)
	}
	
	deinit {
		NotificationCenter.default.removeObserver(observer)
	}
} 

/** This only supports one notification block per notification name at a time */ 

public extension NSObject {

	func startObserving(_ name: NSNotification.Name, object: Any? = nil, queue: OperationQueue? = nil, usingBlock block: @escaping (Notification) -> Void) {
		set(associatedValue: NotificationObserver(forName: name, object: object, queue: queue, usingBlock: block)
		, forKey: "\(associatedValueKey).\(name)")
	}
	
	func stopObserving(_ name: NSNotification.Name) {
		set(associatedValue: nil, forKey: "\(associatedValueKey).\(name)")
	}
}

public extension NSObject {

	class func swizzle(instanceMethod originalSelector: Selector, with newSelector: Selector) {
		swizzle(self
		, 	(originalSelector, class_getInstanceMethod(self, originalSelector))
		,	(newSelector, class_getInstanceMethod(self, newSelector))
		)
	}
		
	class func swizzle(classMethod originalSelector: Selector, with newSelector: Selector) {
		let c = object_getClass(self)!
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

class WeakObjectRef: NSObject {
	weak var object: AnyObject?
	
	init?(_ object: AnyObject?) {
		guard let object = object else {
			return nil
		}
		self.object = object
	}
}
