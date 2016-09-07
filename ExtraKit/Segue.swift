import UIKit

class RootNavigationControllerSegue: UIStoryboardSegue {
	override func perform() {
		sourceViewController.navigationController?.viewControllers = [destinationViewController]
	}
}

class ModalWithNavigationControllerSegue: UIStoryboardSegue {
	override func perform() {
		sourceViewController.presentViewController(UINavigationController(rootViewController: destinationViewController), animated: true, completion: nil)
	}
}

class PushReplaceSegue : UIStoryboardSegue {
	override func perform() {
		if let nvc = sourceViewController.navigationController {
			let n = nvc.viewControllers.count-1
			CATransaction.begin()
			nvc.pushViewController(destinationViewController, animated: true)
			CATransaction.setCompletionBlock {
				nvc.viewControllers.removeAtIndex(n)
			}
			CATransaction.commit()
		}
	}
}

public extension UIStoryboardSegue {

	func performAction(action: AnyObject?) -> Bool {
		guard let action = action as? SegueAction  else { return false }
		action.block(segue: self)
		return true
	}
}

public class SegueAction {
	var block: (segue: UIStoryboardSegue)->Void
	public init(_ block: (segue: UIStoryboardSegue)->Void) {
		self.block = block
	}
}

public extension UIViewController {
	
	class func swizzlePrepareForSegueAction() {
		swizzle(#selector(prepareForSegue(_:sender:)), newSelector: #selector(prepareForSegueAction(_:sender:)))
	}
	
	func prepareForSegueAction(segue: UIStoryboardSegue, sender: AnyObject?) {
		prepareForSegueAction(segue, sender: sender)
		segue.performAction(sender)
	}
}

public extension UIViewController {
	@IBAction func previousViewControllerSegue(segue: UIStoryboardSegue) {
	}
}