import Foundation
import ObjectiveC

private var associatedDictionaryKey = 0

public extension NSObject
{
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
	
	func associatedValueForKey<T>(key: String) -> T?
	{
		return associatedDictionary[key] as? T
	}
	
	func setAssociatedValue(value: AnyObject?, forKey key: String)
	{
		associatedDictionary[key] = value
	}

	func weakAssociatedValueForKey<T>(key: String) -> T?
	{
		return (associatedDictionary[key] as? WeakObjectRef)?.object as? T
	}
	
	func setWeakAssociatedValue(value: AnyObject?, forKey key: String)
	{
		associatedDictionary[key] = WeakObjectRef(object: value)
	}

}

public class WeakObjectRef: NSObject
{
	weak var object: AnyObject?
	
	init(object: AnyObject?) {
		self.object = object
	}
}

public extension NSObject
{
	func startObserving(name: String, object: AnyObject? = nil, queue: NSOperationQueue? = nil, usingBlock block: (NSNotification) -> Void)
	{
		setAssociatedValue(NSNotificationCenter.defaultCenter().addObserverForName(name, object: object, queue: queue, usingBlock: block)
		, forKey: "Observing.\(name).\(object?.hashValue ?? 0)")
	}
	
	func stopObserving(name: String, object: AnyObject? = nil)
	{
		setAssociatedValue(nil, forKey: "Observing.\(name).\(object?.hashValue ?? 0)")
	}
}