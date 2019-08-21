//
//  FluentUI.swift
//  ExtraKit
//
//  Created by rickb on 8/16/19.
//  Copyright © 2019 rickbdotcom LLC. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {

	@discardableResult
	func add(to view: UIView) -> Self {
		view.addSubview(self)
		return self
	}

	@available(iOS 9.0, *)
	@discardableResult
	func addArranged(to view: UIStackView) -> Self {
		view.addArrangedSubview(self)
		return self
	}

	@available(iOS 9.0, *)
	@discardableResult
	func insertArranged(in view: UIStackView, at index: Int) -> Self {
		view.insertArrangedSubview(view, at: index)
		return self
	}

	@discardableResult
	func insert(in view: UIView, below: UIView) -> Self {
		view.insertSubview(self, belowSubview: below)
		return self
	}

	@discardableResult
	func insert(in view: UIView, above: UIView) -> Self {
		view.insertSubview(self, aboveSubview: above)
		return self
	}

	@discardableResult
	func insert(in view: UIView, atIndex index: Int) -> Self {
		view.insertSubview(self, at: index)
		return self
	}

	@discardableResult
	func bringToFront() -> Self {
		superview?.bringSubviewToFront(self)
		return self
	}

	@discardableResult
	func sendToBack() -> Self {
		superview?.sendSubviewToBack(self)
		return self
	}
}

public extension UILabel {

	@discardableResult
	func textColor(_ color: UIColor) -> Self {
		textColor = color
		return self
	}
}

public extension UITextField {

	@discardableResult
	func textColor(_ color: UIColor) -> Self {
		textColor = color
		return self
	}
}

public extension UIView {

	@discardableResult
	func backgroundColor(_ color: UIColor) -> Self {
		self.backgroundColor = color
		return self
	}

	@discardableResult
	func cornerRadius(_ radius: CGFloat) -> Self {
		layer.cornerRadius = radius
		return self
	}

	@discardableResult
	func borderWidth(_ width: CGFloat) -> Self {
		layer.borderWidth = width
		return self
	}

	@discardableResult
	func borderColor(_ color: UIColor) -> Self {
		layer.borderColor = color.cgColor
		return self
	}
}

public extension UIButton {

	@discardableResult
	func titleColor(_ color: UIColor, for: UIControl.State = .normal) -> Self {
		setTitleColor(color, for: .normal)
		return self
	}

}
