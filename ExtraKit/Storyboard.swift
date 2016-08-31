import UIKit

public protocol StoryboardScene {

	var identifier: (String, String) { get }
}

public extension StoryboardScene {
	
	public func storyboard(bundle: NSBundle? = nil) -> UIStoryboard {
		return UIStoryboard(name: identifier.1, bundle: bundle)
	}
	
	public func instantiateViewController(bundle: NSBundle? = nil) -> UIViewController {
		return storyboard(bundle).instantiateViewControllerWithIdentifier(identifier.0)
	}
}

public protocol StoryboardSceneSegue {
	var segueID: String { get }
}

extension UIViewController {

	public func performSegue(segue: StoryboardSceneSegue, sender: AnyObject? = nil) {
		performSegueWithIdentifier(segue.segueID, sender: sender)
	}

	public func performSegue(segue: StoryboardSceneSegue, action: (segue: UIStoryboardSegue)->Void) {
		performSegueWithIdentifier(segue.segueID, sender: SegueAction(action))
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