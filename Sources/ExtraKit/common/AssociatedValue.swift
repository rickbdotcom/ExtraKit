//
//  AssociatedValue.swift
//  ExtraKit
//
//  Created by rickb on 4/18/16.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

import Foundation
import ObjectiveC

/***
// Example usage:
extension UILabel {
	@IBInspectable var lineHeight: Float {
		get { return associatedValue() ?? 0 }
		set { set(associatedValue: newValue) }
	}
}
**/

public extension NSObject {

	var associatedDictionary: NSMutableDictionary {
		return objc_getAssociatedObject(self, &associatedDictionaryKey) as? NSMutableDictionary ?? {
			let dict = NSMutableDictionary()
			objc_setAssociatedObject(self, &associatedDictionaryKey, dict, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			return dict
		}()
	}

	func getAssociatedValue<T>(functionName: String? = #function, _ initialValue: @autoclosure () -> T) -> T {
		let key = associatedKey(functionName: functionName)
		if let value: T = associatedValue(forKey: key) {
			return value
		}
		let value = initialValue()
		set(associatedValue: value, forKey: key)
		return value
	}
	
	func associatedKey(functionName: String? = #function) -> String {
		return [identifier, functionName].compactMap { $0 }.joined(separator: ".")
	}
	
	func associatedValue<T>(functionName: String? = #function) -> T? {
		return associatedValue(forKey: associatedKey(functionName: functionName))
	}

	func set(associatedValue value: Any?, functionName: String? = #function) {
		return set(associatedValue: value, forKey: associatedKey(functionName: functionName))
	}
	
	func weakAssociatedValue<T>(functionName: String? = #function) -> T? {
		return weakAssociatedValue(forKey: associatedKey(functionName: functionName))
	}
	
	func set(weakAssociatedValue value: AnyObject?, functionName: String? = #function) {
		set(weakAssociatedValue: value, forKey: associatedKey(functionName: functionName))
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
private let identifier = "com.rickb.extrakit"
