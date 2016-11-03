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

public protocol StoryboardSceneSegue {
	var segueID: String { get }
}

extension UIViewController {

	public func perform(segue: StoryboardSceneSegue, sender: Any? = nil) {
		self.performSegue(withIdentifier: segue.segueID, sender: sender)
	}

	public func perform(segue: StoryboardSceneSegue, action: @escaping (UIStoryboardSegue)->Void) {
		self.performSegue(withIdentifier: segue.segueID, sender: SegueAction(action))
	}
}

public extension StoryboardScene where Self:RawRepresentable, Self.RawValue == String  {
	var storyboardID: String {
		return rawValue
	}
}

public extension StoryboardSceneSegue where Self:RawRepresentable, Self.RawValue == String  {
	var segueID: String {
		return rawValue
	}
}
