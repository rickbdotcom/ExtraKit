import Foundation
import ObjectiveC

private var associatedDictionaryKey = 0

public extension NSObject {

	var associatedDictionary: NSMutableDictionary {
		get {
			return objc_getAssociatedObject(self, &associatedDictionaryKey) as? NSMutableDictionary
			?? NSMutableDictionary().configure {
				objc_setAssociatedObject(self, &associatedDictionaryKey, $0, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			}
		}
	}

	func getAssociatedValue<T>(module: String? = nil, functionName: String? = #function, initialValue: @autoclosure ()-> T) -> T {
		let key = associatedKey(module: module, functionName: functionName)
		if let value: T = associatedValue(forKey: key) {
			return value
		}

		let value = initialValue()
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

public extension NSObject
{
	func startObserving(_ name: NSNotification.Name, object: AnyHashable? = nil, queue: OperationQueue? = nil, usingBlock block: @escaping (Notification) -> Void) {
		set(associatedValue: NotificationCenter.default.addObserver(forName: name, object: object, queue: queue, using: block)
		, forKey: "\(associatedValueKey).\(name).\(object?.hashValue ?? 0)")
	}
	
	func stopObserving(_ name: NSNotification.Name, object: AnyHashable? = nil) {
		set(associatedValue: nil, forKey: "\(associatedValueKey).\(name).\(object?.hashValue ?? 0)")
	}
}

public extension NSObject {

	class func swizzle(_ originalSelector: Selector, newSelector: Selector) {
		
		guard let originalMethod = class_getInstanceMethod(self, originalSelector)
		, let newMethod = class_getInstanceMethod(self, newSelector) else {
			return
		}
		
		let methodAdded = class_addMethod(self, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))
		if methodAdded {
			class_replaceMethod(self, newSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
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
