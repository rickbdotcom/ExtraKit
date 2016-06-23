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