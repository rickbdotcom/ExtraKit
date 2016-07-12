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

public extension UIViewController {
	
	public func showOKAlert(title: String?, message: String?, completion: (()->Void)? = nil)
	{
		let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
		alert.addAction(UIAlertAction(title: "OK".localized, style: .Default) { _ in
			completion?()
		})
		presentViewController(alert, animated: true, completion: nil)
	}
}

public func showOKAlert(title: String?, message: String?, completion: (()->Void)? = nil)
{
	visibleViewController()?.showOKAlert(title, message: message, completion: completion)
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