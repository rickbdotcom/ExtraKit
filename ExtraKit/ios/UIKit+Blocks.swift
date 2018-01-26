//
//  UIKit+Blocks.swift
//  ExtraKit
//
//  Created by rickb on 4/18/16.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

import UIKit

public extension UIControl {

	private var targetBlocks: NSMutableDictionary { return getAssociatedValue(NSMutableDictionary()) }

	@discardableResult func on<T: UIControl>(_ event: UIControlEvents, block: @escaping (T) -> Void) -> Any? {
		guard self is T else {
			return nil
		}
		let targetBlock = TargetBlock(block)
		addTarget(targetBlock, action: #selector(TargetBlock.execute(_:)), for: event)
		targetBlocks[event.rawValue] = targetBlock
		return targetBlock
	}
}

public extension UIGestureRecognizer {

	private var targetBlock: NSObject? { 
		get { return associatedValue() }
		set { set(associatedValue: newValue) }
	}
	
	convenience init(action: @escaping (UIGestureRecognizer) -> Void) {
		self.init()
		set(action: action)
	}
	
	@discardableResult func set(action: @escaping (UIGestureRecognizer) -> Void) -> Any {
		targetBlock = TargetBlock(action)
		addTarget(targetBlock!, action: #selector(TargetBlock.execute(_:)))
		return targetBlock!
	}
}

public extension UIBarButtonItem {

	private var targetBlock: NSObject? { 
		get { return associatedValue() }
		set { set(associatedValue: newValue) }
	}

	convenience init(action: @escaping (UIBarButtonItem) -> Void) {
		self.init()
		set(action: action)
	}
	
	@discardableResult func set(action: @escaping (UIBarButtonItem) -> Void) -> Any {
		targetBlock = TargetBlock(action)
		target = self
		self.action = #selector(TargetBlock.execute(_:))
		return targetBlock!
	}
}

public extension UITextView {

	var textViewDelegate: TextViewDelegate {
		return getAssociatedValue(TextViewDelegate(textView: self))
	}
}

public class TextViewDelegate: NSObject, UITextViewDelegate {
	
	public var editingDidBegin: ((UITextView) -> Void)?
	public var editingChanged: ((UITextView) -> Void)?
	public var editingDidEnd: ((UITextView) -> Void)?
	public var shouldChangeText: ((UITextView, NSRange, String) -> Bool)?
	
	init(textView: UITextView) {
		super.init()
		textView.delegate = self
	}

	public func textViewDidBeginEditing(_ textView: UITextView) {
		editingDidBegin?(textView)
	}
	
	public func textViewDidEndEditing(_ textView: UITextView) {
		editingDidEnd?(textView)
	}
	
	public func textViewDidChange(_ textView: UITextView) {
		editingChanged?(textView)
	}
	
	public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		return shouldChangeText?(textView, range, text) ?? true
	}
}

class TargetBlock<T: NSObject>: NSObject {
	
	var block: (T) -> Void
	
	init(_ block: @escaping (T) -> Void) {
		self.block = block
	}
	
	@objc func execute(_ control: UIControl) {
		if let control = control as? T {
			block(control)
		}
	}
}
