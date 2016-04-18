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