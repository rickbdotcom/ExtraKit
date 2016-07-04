import UIKit

public protocol StoryboardScene {

	var storyboardName: String { get }
	var storyboardID: String { get }
}

public extension StoryboardScene {
	
	public func storyboard(bundle: NSBundle? = nil) -> UIStoryboard {
		return UIStoryboard(name: storyboardName, bundle: bundle)
	}
	
	public func instantiateViewController(bundle: NSBundle? = nil) -> UIViewController {
		return storyboard(bundle).instantiateViewControllerWithIdentifier(storyboardID)
	}
	
	public func instantiateTypedViewController<T>(bundle: NSBundle? = nil) -> T? {
		return instantiateViewController(bundle) as? T
	}
}

public protocol StoryboardSceneSegue {
	var segueID: String { get }
}

extension UIViewController {

	public func performSegue(segue: StoryboardSceneSegue, sender: AnyObject? = nil) {
		performSegueWithIdentifier(segue.segueID, sender: sender)
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
