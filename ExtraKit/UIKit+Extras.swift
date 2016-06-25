import UIKit

public extension UIView {

	func textFieldBecomeFirstResponder() -> Bool {
		if let tf = self as? UITextField {
			return tf.becomeFirstResponder()
		}
		for sv in subviews {
			if sv.textFieldBecomeFirstResponder() {
				return true
			}
		}
		return false
	}
}

public extension UIViewController {

	func prepareForSegue(segue: UIStoryboardSegue, action: AnyObject?) -> Bool {
		guard let action = action as? SegueAction  else { return false }
		action.block(segue: segue)
		return true
	}
}

public class SegueAction {
	var block: (segue: UIStoryboardSegue)->Void
	init(_ block: (segue: UIStoryboardSegue)->Void) {
		self.block = block
	}
}

public extension UIViewController {

	func typedParentViewController<T>() -> T? {
		return self as? T ?? parentViewController?.typedParentViewController()
	}
	
	func typedChildViewController<T>() -> T? {
		return childViewControllers.find { $0 is T } as? T
	}
}

public extension UIView {

	func typedSuperview<T>() -> T? {
		return self as? T ?? superview?.typedSuperview()
	}

	func typedParentViewController<T>() -> T? {
		return self as? T ?? parentViewController?.typedParentViewController()
	}

    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.nextResponder()
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

public extension UIViewController {
	@IBAction func previousViewControllerSegue(segue: UIStoryboardSegue) {
	}
}

public extension UIView {
	
	@IBInspectable var borderColor: UIColor? {
		get {
			return layer.borderColor != nil ? UIColor(CGColor: layer.borderColor!) : nil
		}
		set {
			layer.borderColor = newValue?.CGColor
		}
	}
}

public class StoryboardSegueWithCompletion: UIStoryboardSegue {
	public var completion: (() -> Void)?

    public override func perform() {
		CATransaction.begin()
        super.perform()
		CATransaction.setCompletionBlock(completion)
		CATransaction.commit()
    }
}