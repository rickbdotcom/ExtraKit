import UIKit

private let associatedValueKey = "com.rickb.extrakit.UIControl.actionBlocks"

public extension UIControl
{
	func addControlEvents(controlEvents: UIControlEvents = .TouchUpInside, block: (UIControl)->Void) -> AnyObject {
		let actionBlock = ControlActionBlock(block: block)
		addTarget(actionBlock, action: #selector(ControlActionBlock.execute(_:)), forControlEvents: controlEvents)
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

public class ControlActionBlock: NSObject
{
	var block: (UIControl)->Void
	
	init(block: (UIControl)->Void) {
		self.block = block
	}
	
	func execute(control: UIControl) {
		block(control)
	}
}