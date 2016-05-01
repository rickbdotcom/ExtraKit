import UIKit

public extension UIControl
{
	func addControlEvents(controlEvents: UIControlEvents, block: ()->Void) -> AnyObject {
		let actionBlock = ControlActionBlock(block: block)
		addTarget(actionBlock, action: #selector(ControlActionBlock.execute), forControlEvents: controlEvents)
		actionBlocks.addObject(actionBlock)
		return actionBlock
	}
	
	var actionBlocks: NSMutableSet {
		if let set: NSMutableSet = associatedValueForKey("UIControl.actionBlocks") {
			return set
		}
		let set = NSMutableSet()
		setAssociatedValue(set, forKey: "UIControl.actionBlocks")
		return set
	}
}

public class ControlActionBlock: NSObject
{
	var block: ()->Void
	
	init(block: ()->Void) {
		self.block = block
	}
	
	func execute() {
		block()
	}
}