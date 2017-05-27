import UIKit

public protocol StoryboardScene {

	var identifier: (String, String) { get }
}

public extension StoryboardScene {
	
	public func storyboard(_ bundle: Bundle? = nil) -> UIStoryboard {
		return UIStoryboard(name: identifier.1, bundle: bundle)
	}
	
	public func instantiateViewController(_ bundle: Bundle? = nil) -> UIViewController {
		return storyboard(bundle).instantiateViewController(withIdentifier: identifier.0)
	}
}

extension UIViewController {

	public func performSegue(withIdentifier identifier: String, action: @escaping (UIStoryboardSegue)->Void) {
		self.performSegue(withIdentifier: identifier, sender: SegueAction(action))
	}
}
