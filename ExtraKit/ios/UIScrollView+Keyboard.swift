//
//  UIScrollView+Keyboard.swift
//  ExtraKit
//
//  Created by rickb on 4/18/16.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

import UIKit

public extension UIScrollView {

	func adjustContentInsetForKeyboardFrame() {
		set(associatedValue: KeyboardNotificationObserver(scrollView: self))
	}
}

class KeyboardNotificationObserver: NSObject {

	weak var scrollView: UIScrollView?
	var contentInset: UIEdgeInsets?
	var scrollIndicatorInsets: UIEdgeInsets?
	
	init(scrollView: UIScrollView) {
		super.init()

		self.scrollView = scrollView
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	}
	
	@objc func keyboardWillChangeFrame(_ notification: Notification) {
		guard let scrollView = self.scrollView else {
			return
		}
		if contentInset == nil {
			contentInset = scrollView.contentInset
		}
		if scrollIndicatorInsets == nil {
			scrollIndicatorInsets = scrollView.scrollIndicatorInsets
		}
		scrollView.contentInset.bottom = adjustedKeyboardFrameHeight(notification)
		scrollView.scrollIndicatorInsets.bottom = scrollView.contentInset.bottom
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

	func adjustedKeyboardFrameHeight(_ note: Notification) -> CGFloat {
		guard let scrollView = scrollView, let keyboardFrame = note.keyboardFrameEnd else {
			return 0
		}
		
		var h = keyboardFrame.size.height
		let dh = UIScreen.main.bounds.size.height-scrollView.convert(scrollView.bounds, to: UIScreen.main.coordinateSpace).maxY
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

	@IBOutlet public weak var viewForKeyboardReveal: UIView? {
		get { return weakAssociatedValue() }
		set { set(weakAssociatedValue: newValue) }
	}
}

public extension Notification {

	var keyboardFrameEnd: CGRect? {
        if let info = (self as Notification).userInfo, let value = info[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            return value.cgRectValue
        } else {
            return nil
        }
    }
}
