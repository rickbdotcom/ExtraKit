//
//  StoryboardScene.swift
//  ExtraKit
//
//  Created by rickb on 4/18/16.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

import UIKit

public protocol Nib {
	associatedtype OwnerClass
	associatedtype TopLevelObjectClass

	var nibName: String { get }
}

public protocol NibInit {
	init(nibName: String?, bundle: Bundle?)
}

public extension Nib {

	public func nib(bundle: Bundle? = nil) -> UINib {
		return UINib(nibName: nibName, bundle: nil)
	}
	
	public func instantiateOwner<T>(bundle: Bundle? = nil) -> T where T == OwnerClass, T: NibInit {
		return OwnerClass(nibName: nibName, bundle: bundle)
	}
	
	public func instantiate(bundle: Bundle? = nil, withOwner owner: OwnerClass? = nil) -> TopLevelObjectClass {
		return nib(bundle: bundle).instantiate(withOwner: owner, options: nil)[0] as! TopLevelObjectClass
	}

	public func instantiateObjects(bundle: Bundle? = nil, withOwner owner: OwnerClass? = nil) -> [Any] {
		return nib(bundle: bundle).instantiate(withOwner: owner, options: nil)
	}
}

public extension UIView {
	
	@IBInspectable var nibName: String? {
		get { return associatedValue() }
		set { set(associatedValue: newValue) }
	}

	@IBInspectable var nibContentView: UIView? {
		get { return associatedValue() }
		set { 
			nibContentView?.removeFromSuperview()
			set(associatedValue: newValue) 
			if let nibContentView = newValue {
				addSubview(nibContentView)
				nibContentView.translatesAutoresizingMaskIntoConstraints = false
				nibContentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
				nibContentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
				nibContentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
				nibContentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
			} 
		}
	}
	
	class func swizzleLoadFromNib() {
		swizzle(instanceMethod: #selector(awakeFromNib), with: #selector(awakeFromNib_loadFromNib))
	}
		
	@objc func awakeFromNib_loadFromNib() {
		awakeFromNib_loadFromNib()
		if let nibName = nibName {
			nibContentView = UINib(nibName: nibName, bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil).first as? UIView
		}
	}
}
