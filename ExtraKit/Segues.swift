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