//
//  UIScrollView+Keyboard.swift
//  ExtraKit
//
//  Created by rickb on 4/18/16.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

import UIKit

public extension UIScrollView {

	@IBInspectable var adjustContentInsetForKeyboardFrame: Bool {
		set {
			if newValue {
				set(associatedValue: KeyboardNotificationObserver(scrollView: self))
			} else {
				set(associatedValue: nil)
			}
		}
		get {
			let value: KeyboardNotificationObserver? = associatedValue()
			return value != nil
		}
	}
}

class KeyboardNotificationObserver: NSObject {

	weak var scrollView: UIScrollView?
	var contentInset: UIEdgeInsets?
	var scrollIndicatorInsets: UIEdgeInsets?
	
	init(scrollView: UIScrollView) {
		super.init()

		self.scrollView = scrollView
		if let keyboardFrame = keyboardHeightObserver?.keyboardFrame {
			keyboardFrameUpdate(keyboardFrame)
		}
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	@objc func keyboardWillChangeFrame(_ notification: Notification) {
		guard let keyboardFrame = notification.keyboardFrameEnd else {
			return
		}
		keyboardFrameUpdate(keyboardFrame)
	}
	
	func keyboardFrameUpdate(_ keyboardFrame: CGRect) {
		guard let scrollView = self.scrollView else {
			return
		}
		if contentInset == nil {
			contentInset = scrollView.contentInset
		}
		if scrollIndicatorInsets == nil {
			scrollIndicatorInsets = scrollView.scrollIndicatorInsets
		}
		scrollView.contentInset.bottom = adjustedKeyboardFrameHeight(keyboardFrame)
		scrollView.scrollIndicatorInsets.bottom = scrollView.contentInset.bottom

		scrollToVisibleResponder(keyboardFrame)
	}
	
	@objc func keyboardWillHide(_ note: Notification) {
		guard let scrollView = self.scrollView else {
			return
		}
		if let contentInset = self.contentInset {
			scrollView.contentInset = contentInset
			self.contentInset = nil
		}
		if let scrollIndicatorInsets = self.scrollIndicatorInsets {
			scrollView.scrollIndicatorInsets = scrollIndicatorInsets
			self.scrollIndicatorInsets = nil
		}
	}

	func scrollToVisibleResponder(_ keyboardFrame: CGRect) {
		if let scrollView = scrollView
		, let window = scrollView.window
		, let revealView = scrollView.findFirstResponder()?.viewForKeyboardReveal
		, scrollView.convert(window.convert(keyboardFrame, from: nil), from: nil).intersects(revealView.frame) {
			scrollView.scrollRectToVisible(revealView.frame, animated: true)
		}
	}

	func adjustedKeyboardFrameHeight(_ keyboardFrame: CGRect) -> CGFloat {
		guard let scrollView = scrollView else {
			return 0
		}
		var h = keyboardFrame.size.height
		let dh = UIScreen.main.bounds.size.height - scrollView.convert(scrollView.bounds, to: UIScreen.main.coordinateSpace).maxY
		if dh > 0 {
			h -= dh
		}
		if h < 0 {
			h = 0
		}
		return h
	}
}

public extension UIResponder {

	@IBOutlet weak var viewForKeyboardReveal: UIView? {
		get { return weakAssociatedValue() }
		set { set(weakAssociatedValue: newValue) }
	}
}

public extension Notification {

	var keyboardFrameEnd: CGRect? {
		if let info = (self as Notification).userInfo, let value = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            return value.cgRectValue
        } else {
            return nil
        }
    }
}

open class KeyboardHeightConstraint: NSLayoutConstraint {

	open override func awakeFromNib() {
		super.awakeFromNib()
		setupNotifications()
	}

	public override init() {
		super.init()
		setupNotifications()
	}

	private func setupNotifications() {
		constant = keyboardHeightObserver?.keyboardFrame?.height ?? 0
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	}

	@objc func keyboardWillChangeFrame(_ notification: Notification) {
		if let keyboardFrame = notification.keyboardFrameEnd {
			constant = keyboardFrame.size.height
		}    
	}

	@objc func keyboardWillHide(_ note: Notification) {
		constant = 0
	}
}

var keyboardHeightObserver: KeyboardHeightObserver?

public func observeKeyboardNotifications() {
	keyboardHeightObserver = KeyboardHeightObserver()
}

class KeyboardHeightObserver: NSObject {
	
	var keyboardFrame: CGRect?
	
	override init() {
		super.init()
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	}

	@objc func keyboardWillChangeFrame(_ notification: Notification) {
		if let keyboardFrame = notification.keyboardFrameEnd {
			self.keyboardFrame = keyboardFrame
		}
	}
	
	@objc func keyboardWillHide(_ note: Notification) {
		keyboardFrame = nil
	}
}
