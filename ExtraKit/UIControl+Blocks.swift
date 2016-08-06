import UIKit

private let associatedValueKey = "com.rickb.extrakit.UIControl.actionBlocks"

public extension UIControl
{

	func addControlEvents<T:UIControl>(controlEvents: UIControlEvents = .TouchUpInside, block: (T)->Void) -> AnyObject? {
		guard self is T else { return nil }
		
		let actionBlock = ControlActionBlock(block: block)
		addTarget(actionBlock, action: #selector(ControlActionBlock.execute(_:)), forControlEvents: controlEvents)
		actionBlocks.addObject(actionBlock)
		return actionBlock
	}

	func addControlEvents(controlEvents: UIControlEvents = .TouchUpInside, block: ()->Void) -> AnyObject? {
		let actionBlock = VoidControlActionBlock(block: block)
		addTarget(actionBlock, action: #selector(VoidControlActionBlock.execute), forControlEvents: controlEvents)
		actionBlocks.addObject(actionBlock)
		return actionBlock
	}
	
	var actionBlocks: NSMutableSet {
		if let set: NSMutableSet = associatedValueForKey(associatedValueKey) {
			return set
		}
		let set = NSMutableSet()
		setAssociatedValue(set, forKey: associatedValueKey)
		return set
	}
}

public class VoidControlActionBlock: NSObject {
	
	var block: ()->Void
	
	init(block: ()->Void) {
		self.block = block
	}
	
	func execute() {
		block()
	}
}
public class ControlActionBlock<T:UIControl>: NSObject {
	
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