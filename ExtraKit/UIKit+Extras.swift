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

public extension UIAlertController {

	public static func alert(title title: String? = nil, message: String? = nil, preferredStyle: UIAlertControllerStyle = .Alert) -> UIAlertController {
		return UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
	}
	
	public func ok(style: UIAlertActionStyle = .Default, action inAction: (()->Void)? = nil) -> UIAlertController {
		return action(title: "OK".localized, style: style, action: inAction)
	}

	public func cancel(style: UIAlertActionStyle = .Cancel, inAction: (()->Void)? = nil) -> UIAlertController {
		return action(title: "Cancel".localized, style: style, action: inAction)
	}
	
	public func action(title title: String?, style: UIAlertActionStyle = .Default, action: (()->Void)? = nil) -> UIAlertController {
		addAction(UIAlertAction(title: title, style: style) { _ in
			action?()
		})
		return self
	}
	
	public func show(viewController: UIViewController? = nil, animated: Bool = true, completion: (() -> Void)? = nil) {
		(viewController ?? visibleViewController())?.presentViewController(self, animated: animated, completion: completion)
	}
}

public func visibleViewController() -> UIViewController? {
	return UIApplication.sharedApplication().delegate?.window??.visibleViewController
}

public extension UIWindow {
    public var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }

    public static func getVisibleViewControllerFrom(vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                return vc
            }
        }
    }
}

public extension UINavigationBar
{
	public func makeTransparent(transparent: Bool)
	{
		setBackgroundImage(transparent ? UIImage() : nil, forBarMetrics: UIBarMetrics.Default)
		shadowImage = transparent ? UIImage() : nil
	}
}