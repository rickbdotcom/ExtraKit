import UIKit

public extension UIStoryboardSegue {

	@discardableResult func perform(action: Any?) -> Bool {
		guard let action = action as? SegueAction  else {
			return false
		}
		action.block(self)
		return true
	}
}

open class SegueAction {
	var block: (UIStoryboardSegue)->Void

	public init(_ block: @escaping (UIStoryboardSegue)->Void) {
		self.block = block
	}
}

public extension UIViewController {
	
	class func swizzlePrepareForSegueAction() {
		swizzle(instanceMethod: #selector(prepare(for:sender:)), with: #selector(prepareForSegueAction(_:sender:)))
	}
	
	@objc func prepareForSegueAction(_ segue: UIStoryboardSegue, sender: AnyObject?) {
		prepareForSegueAction(segue, sender: sender)
		segue.perform(action: sender)
	}
}

extension UIViewController {

	public func performSegue(withIdentifier identifier: String, action: @escaping (UIStoryboardSegue)->Void) {
		self.performSegue(withIdentifier: identifier, sender: SegueAction(action))
	}
}
