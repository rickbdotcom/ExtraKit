//
//  UIKit+Blocks.swift
//  ExtraKit
//
//  Created by rickb on 4/18/16.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

import ExtraKitCore
import UIKit

private let targetBlockAction = #selector(TargetBlock.execute(_:))

public extension UIControl {

	private var targetBlocks: NSMutableDictionary { return associatedValue(default: NSMutableDictionary()) }

	@discardableResult func on<T: UIControl>(_ event: UIControl.Event, block: ((T) -> Void)?) -> Any? {
		if let block = block {
			let targetBlock = add(event, block: block)
			targetBlocks[event.rawValue] = targetBlock
			return targetBlock
		} else if let targetBlock = targetBlocks[event.rawValue] {
			removeTarget(targetBlock, action: nil, for: event)
			targetBlocks[event.rawValue] = nil
		}
		return nil
	}
	
	func add<T: UIControl>(_ event: UIControl.Event, block: @escaping (T) -> Void) -> Any? {
		guard self is T else {
			return nil
		}
		let targetBlock = TargetBlock(block)
		addTarget(targetBlock, action: targetBlockAction, for: event)
		return targetBlock	
	}
}

public extension UIGestureRecognizer {

	private var targetBlock: Any? { 
		get { return associatedValue() }
		set { set(associatedValue: newValue) }
	}
	
	convenience init(action: @escaping (UIGestureRecognizer) -> Void) {
		self.init()
		set(action: action)
	}
	
	@discardableResult func set(action: ((UIGestureRecognizer) -> Void)?) -> Any? {
		if let action = action {
			self.targetBlock = add(action: action)
			return self.targetBlock
		} else if let targetBlock = targetBlock {
			removeTarget(targetBlock, action: nil)
			self.targetBlock = nil
		}
		return nil
	}

	func add(action: @escaping (UIGestureRecognizer) -> Void) -> Any? {
		let targetBlock = TargetBlock(action)
		addTarget(targetBlock, action: targetBlockAction)
		return targetBlock
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
	
	@discardableResult func set(action: ((UIBarButtonItem) -> Void)?) -> Any? {
		if let action = action { 
			targetBlock = TargetBlock(action)
			target = targetBlock
			self.action = targetBlockAction
			return targetBlock
		} else {
			targetBlock = nil
			return nil
		}
	}
}

class TargetBlock<T: NSObject>: NSObject {
	
	var block: (T) -> Void
	
	init(_ block: @escaping (T) -> Void) {
		self.block = block
	}
	
	@objc func execute(_ control: Any?) {
		if let control = control as? T {
			block(control)
		}
	}
}
