//
//  StoryboardScene.swift
//  ExtraKit
//
//  Created by rickb on 4/18/16.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

import UIKit

public protocol NibInstantiable {
	associatedtype OwnerClass
	associatedtype TopLevelObjectClass

	var nibName: String { get }
}

public struct NibDescription<OwnerClass, TopLevelObjectClass>: NibInstantiable {

	public let nibName: String
	public let ownerClass: OwnerClass.Type
	public let topLevelObjectClass: TopLevelObjectClass.Type

	public init(nibName: String, ownerClass: OwnerClass.Type, topLevelObjectClass: TopLevelObjectClass.Type) {
		self.nibName = nibName
		self.ownerClass = ownerClass
		self.topLevelObjectClass = topLevelObjectClass
	}
}

public protocol NibInit {
	init(nibName: String?, bundle: Bundle?)
}

public extension NibInstantiable {

	func nib(bundle: Bundle? = nil) -> UINib {
		return UINib(nibName: nibName, bundle: nil)
	}
	
	func instantiateOwner<T>(bundle: Bundle? = nil) -> T where T == OwnerClass, T: NibInit {
		return OwnerClass(nibName: nibName, bundle: bundle)
	}
	
	func instantiate(bundle: Bundle? = nil, withOwner owner: OwnerClass? = nil) -> TopLevelObjectClass {
		return nib(bundle: bundle).instantiate(withOwner: owner, options: nil)[0] as! TopLevelObjectClass
	}

	func instantiateObjects(bundle: Bundle? = nil, withOwner owner: OwnerClass? = nil) -> [Any] {
		return nib(bundle: bundle).instantiate(withOwner: owner, options: nil)
	}
}

public extension UIView {
	
	@IBInspectable var nibName: String? {
		get { return associatedValue() }
		set { 
			set(associatedValue: newValue) 
			if let nibName = nibName {
				nibContentView = UINib.instantiate(nibName, bundle: nil, withOwner: self)
			} else {
				nibContentView = nil
			}
		}
	}

	convenience init(nibName: String) {
		self.init(frame: .zero)
		self.nibName = nibName
		translatesAutoresizingMaskIntoConstraints = false
	}
	
	var nibContentView: UIView? {
		get { return associatedValue() }
		set { 
			nibContentView?.removeFromSuperview()
			set(associatedValue: newValue)
			if #available(iOS 9.0, *) {
				nibContentView?.add(to: self).pin()
			} else {
			}
		}
	}
}

public extension UINib {
	static func instantiate<T>(_ nibName: String, bundle: Bundle? = nil, withOwner owner: Any? = nil) -> T? {
		return UINib(nibName: nibName, bundle: bundle).instantiate(withOwner: owner, options: nil).first as? T
	}
}
