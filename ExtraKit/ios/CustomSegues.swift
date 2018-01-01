import UIKit

class RootNavigationControllerSegue: UIStoryboardSegue {

	override func perform() {
		source.navigationController?.viewControllers = [destination]
	}
}

class ModalWithNavigationControllerSegue: UIStoryboardSegue {

	override func perform() {
		source.present(UINavigationController(rootViewController: destination).configure {
			$0.modalTransitionStyle = destination.modalTransitionStyle
		}, animated: true, completion: nil)
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

public extension UIViewController {

	@IBAction func unwindToPreviousViewController(_ segue: UIStoryboardSegue) {
	}
}

