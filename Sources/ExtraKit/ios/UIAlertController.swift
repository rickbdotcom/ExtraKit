//
//  UIAlertController.swift
//  ExtraKit
//
//  Created by rickb on 4/18/16.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

import UIKit

public extension UIAlertController {

	class func alert(title: String? = nil, message: String? = nil, preferredStyle: UIAlertController.Style = .alert) -> UIAlertController {
		return UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
	}
	
	@discardableResult func ok(_ style: UIAlertAction.Style = .default, action inAction: ((UIAlertController)->Void)? = nil) -> Self {
		return action(title: NSLocalizedString("OK", comment: ""), style: style, action: inAction)
	} 

	@discardableResult func cancel(_ style: UIAlertAction.Style = .cancel, inAction: ((UIAlertController)->Void)? = nil) -> Self {
		return action(title: NSLocalizedString("Cancel", comment: ""), style: style, action: inAction)
	}
	
	@discardableResult func action(title: String?, style: UIAlertAction.Style = .default, action: ((UIAlertController)->Void)? = nil) -> Self {
		addAction(UIAlertAction(title: title, style: style) { [weak self] _ in
			if let alert = self {
				action?(alert)
			}
		})
		return self
	}

	@discardableResult func textField(configurationHandler: ((UITextField) -> Void)? = nil) -> Self {
		addTextField(configurationHandler: configurationHandler)
		return self
	}

	@discardableResult func show(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) -> Self {
		viewController.present(self, animated: animated, completion: completion)
			return self
	}
}
