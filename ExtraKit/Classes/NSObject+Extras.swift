import Foundation
import ObjectiveC

private var associatedDictionaryKey = 0

public extension NSObject {

	var associatedDictionary: NSMutableDictionary {
		get {
			if let dict = objc_getAssociatedObject(self, &associatedDictionaryKey) as? NSMutableDictionary {
				return dict
			}
			let dict = NSMutableDictionary()
			objc_setAssociatedObject(self, &associatedDictionaryKey, dict, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			return dict
		}
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
		
		let originalMethod = class_getInstanceMethod(self, originalSelector)
		let newMethod = class_getInstanceMethod(self, newSelector)
		
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

class KVOObserver: NSObject {

	var keyPath: String
	var block:(Void)->Void
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
	 	block()
	}
	
	init(keyPath: String, block: @escaping (Void)->Void) {
		self.keyPath = keyPath
		self.block = block
		super.init()
	}
}

public extension NSObject {

	@discardableResult func observe(keyPath: String, block: @escaping (Void)->Void) -> AnyHashable {
		let observer = KVOObserver(keyPath: keyPath, block: block)
		addObserver(observer, forKeyPath: keyPath, options: .new, context: nil)
		return observer
	}
	
	func stopObserving(keyPathObserver: AnyHashable?) {
		if let observer = keyPathObserver as? KVOObserver {
			removeObserver(observer, forKeyPath: observer.keyPath)
		}
	}
}
