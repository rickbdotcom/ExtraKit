import UIKit

private let associatedValueKey = "com.rickb.extrakit.actionBlocks"


public extension NSObject {
	
	var actionBlocks: NSMutableSet {
		if let set: NSMutableSet = associatedValue(forKey: associatedValueKey) {
			return set
		}
		let mset = NSMutableSet()
		set(associatedValue: mset, forKey: associatedValueKey)
		return mset
	}
	
	func removeActionBlock(_ block: Any?) {
		if let block = block {
			actionBlocks.remove(block)
		}
	}
}

public extension UIControl {

	@discardableResult func addControlEvents<T:UIControl>(_ controlEvents: UIControlEvents = .touchUpInside, block: @escaping (T)->Void) -> Any? {
		guard self is T else {
			return nil
		}
		return ActionBlock(block).configure {
			addTarget($0, action: #selector(ActionBlock.execute(_:)), for: controlEvents)
			self.actionBlocks.add($0)
		}
	}

	@discardableResult func addControlEvents(_ controlEvents: UIControlEvents = .touchUpInside, block: @escaping ()->Void) -> Any {
		return VoidActionBlock(block).configure {
			addTarget($0, action: #selector(VoidActionBlock.execute), for: controlEvents)
			actionBlocks.add($0)
		}
	}
}

public extension UIGestureRecognizer {

	convenience init(block: @escaping (UIGestureRecognizer)->Void) {
		self.init()
		addAction(block)
	}
	
	@discardableResult func addAction(_ block: @escaping (UIGestureRecognizer)->Void) -> Any {
		return ActionBlock(block).configure {
			addTarget($0, action: #selector(ActionBlock.execute(_:)))
			self.actionBlocks.add($0)
		}
	}
}

public extension UIBarButtonItem {

	convenience init(block: @escaping (UIBarButtonItem)->Void) {
		self.init()
		setBlock(block)
	}
	
	@discardableResult func setBlock(_ block: @escaping (UIBarButtonItem)->Void) -> Any {
		return ActionBlock(block).configure {
			target = $0
			action = #selector(ActionBlock.execute(_:))
			self.actionBlocks.removeAllObjects()
			self.actionBlocks.add($0)
		}
	}
}

class VoidActionBlock: NSObject {
	
	var block: ()->Void
	
	init(_ block: @escaping ()->Void) {
		self.block = block
	}
	
	func execute() {
		block()
	}
}

class ActionBlock<T:NSObject>: NSObject {
	
	var block: (T)->Void
	
	init(_ block: @escaping (T)->Void) {
		self.block = block
	}
	
	func execute(_ control: UIControl) {
		if let control = control as? T {
			block(control)
		}
	}
}
