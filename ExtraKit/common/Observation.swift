//
//  Observation.swift
//  ExtraKit
//
//  Created by rickb on 4/18/16.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

import Foundation

/** This only supports one notification block per notification name at a time */ 

public extension NSObject {

	func startObserving(_ name: Notification.Name, object: Any? = nil, queue: OperationQueue? = nil, usingBlock block: @escaping (Notification) -> Void) {
		set(associatedValue: NotificationObserver(forName: name, object: object, queue: queue, usingBlock: block)
		, forKey: "\(associatedValueKey).\(name)")
	}
	
	func stopObserving(_ name: Notification.Name) {
		set(associatedValue: nil, forKey: "\(associatedValueKey).\(name)")
	}
	
	var kvoObservations: NSMutableSet { return getAssociatedValue(NSMutableSet()) }
}

public func kvoBind<T: NSObject, U: NSObject, V>(_ element: T?, to object: U?, keyPath: KeyPath<U, V>, changeHandler: @escaping (T, U) -> Void) {
	element?.kvoObservations.removeAllObjects()
	if let object = object {
		element?.kvoObservations.add(object.observe(keyPath, options: [.initial, .new]) { [weak element] object, _ in
			if let element = element {
				changeHandler(element, object)
			}
		})
	}
}

private let associatedValueKey = "com.rickb.extrakit.Observing"

class NotificationObserver {
	
	var observer: Any
	
	init(forName name: Notification.Name, object: Any? = nil, queue: OperationQueue? = nil, usingBlock block: @escaping (Notification) -> Void) {
		 observer = NotificationCenter.default.addObserver(forName: name, object: object, queue: queue, using: block)
	}
	
	deinit {
		NotificationCenter.default.removeObserver(observer)
	}
}
