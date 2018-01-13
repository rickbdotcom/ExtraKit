import Foundation
import ObjectiveC

public extension NSObject {

	var associatedDictionary: NSMutableDictionary {
		return objc_getAssociatedObject(self, &associatedDictionaryKey) as? NSMutableDictionary ?? {
			let dict = NSMutableDictionary()
			objc_setAssociatedObject(self, &associatedDictionaryKey, dict, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			return dict
		}()
	}

	func getAssociatedValue<T>(module: String? = nil, functionName: String? = #function, _ initialValue: @autoclosure () -> T) -> T {
		let key = associatedKey(module: module, functionName: functionName)
		if let value: T = associatedValue(forKey: key) {
			return value
		}
		let value = initialValue()
		set(associatedValue: value, forKey: key)
		return value
	}
	
	func associatedKey(module: String? = nil, functionName: String? = #function) -> String {
		return [module ?? Bundle(for: self.classForCoder).bundleIdentifier, functionName].flatMap { $0 }.joined(separator: ".")
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

class WeakObjectRef: NSObject {
	weak var object: AnyObject?
	
	init?(_ object: AnyObject?) {
		guard let object = object else {
			return nil
		}
		self.object = object
	}
}

private var associatedDictionaryKey = 0
