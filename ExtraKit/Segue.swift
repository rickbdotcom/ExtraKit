import UIKit

class RootNavigationControllerSegue: UIStoryboardSegue {
	override func perform() {
		source.navigationController?.viewControllers = [destination]
	}
}

class ModalWithNavigationControllerSegue: UIStoryboardSegue {
	override func perform() {
		source.present(UINavigationController(rootViewController: destination), animated: true, completion: nil)
	}
}

class PushReplaceSegue : UIStoryboardSegue {
	override func perform() {
		if let nvc = source.navigationController {
			let n = nvc.viewControllers.count-1
			CATransaction.begin()
			nvc.pushViewController(destination, animated: true)
			CATransaction.setCompletionBlock {
				nvc.viewControllers.remove(at: n)
			}
			CATransaction.commit()
		}
	}
}

public extension UIStoryboardSegue {

	@discardableResult func performAction(_ action: AnyObject?) -> Bool {
		guard let action = action as? SegueAction  else { return false }
		action.block(self)
		return true
	}
}

open class SegueAction {
	var block: (_ segue: UIStoryboardSegue)->Void
	public init(_ block: @escaping (_ segue: UIStoryboardSegue)->Void) {
		self.block = block
	}
}

public extension UIViewController {
	
	class func swizzlePrepareForSegueAction() {
		swizzle(#selector(prepare(for:sender:)), newSelector: #selector(prepareForSegueAction(_:sender:)))
	}
	
	func prepareForSegueAction(_ segue: UIStoryboardSegue, sender: AnyObject?) {
		prepareForSegueAction(segue, sender: sender)
		segue.performAction(sender)
	}
}

public extension UIViewController {
	@IBAction func previousViewControllerSegue(_ segue: UIStoryboardSegue) {
	}
}
