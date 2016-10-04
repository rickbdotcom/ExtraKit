import UIKit

private let associatedValueKey = "com.rickb.extrakit.actionBlocks"


public extension NSObject {
	
	var actionBlocks: NSMutableSet {
		if let set: NSMutableSet = associatedValueForKey(associatedValueKey) {
			return set
		}
		let set = NSMutableSet()
		setAssociatedValue(set, forKey: associatedValueKey)
		return set
	}
}

public extension UIControl {

	func addControlEvents<T:UIControl>(controlEvents: UIControlEvents = .TouchUpInside, block: (T)->Void) -> AnyObject? {
		guard self is T else { return nil }
		
		return ActionBlock(block: block).configure {
			addTarget($0, action: #selector(ActionBlock.execute(_:)), forControlEvents: controlEvents)
			self.actionBlocks.addObject($0)
		}
	}

	func addControlEvents(controlEvents: UIControlEvents = .TouchUpInside, block: ()->Void) -> AnyObject? {
		return VoidActionBlock(block: block).configure {
			addTarget($0, action: #selector(VoidActionBlock.execute), forControlEvents: controlEvents)
			actionBlocks.addObject($0)
		}
	}
}

public extension UIGestureRecognizer {

	convenience init(block: (UIGestureRecognizer)->Void) {
		self.init()
		addAction(block)
	}
	
	func addAction(block: (UIGestureRecognizer)->Void) -> AnyObject? {
		return ActionBlock(block: block).configure {
			addTarget($0, action: #selector(ActionBlock.execute(_:)))
			self.actionBlocks.addObject($0)
		}
	}
}

public extension UIBarButtonItem {

	convenience init(block: (UIBarButtonItem)->Void) {
		self.init()
		setBlock(block)
	}
	
	func setBlock(block: (UIBarButtonItem)->Void) -> AnyObject? {
		return ActionBlock(block: block).configure {
			target = $0
			action = #selector(ActionBlock.execute(_:))
			self.actionBlocks.removeAllObjects()
			self.actionBlocks.addObject($0)
		}
	}
}

public class VoidActionBlock: NSObject {
	
	var block: ()->Void
	
	init(block: ()->Void) {
		self.block = block
	}
	
	func execute() {
		block()
	}
}
public class ActionBlock<T:NSObject>: NSObject {
	
	var block: (T)->Void
	
	init(block: (T)->Void) {
		self.block = block
	}
	
	func execute(control: UIControl) {
		if let control = control as? T {
			block(control)
		}
	}
}
