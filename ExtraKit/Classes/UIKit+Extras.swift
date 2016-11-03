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
		return self as? T ?? parent?.typedParentViewController()
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
            parentResponder = parentResponder!.next
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
			return layer.borderColor != nil ? UIColor(cgColor: layer.borderColor!) : nil
		}
		set {
			layer.borderColor = newValue?.cgColor
		}
	}
}

public extension UIAlertController {

	public static func alert(title: String? = nil, message: String? = nil, preferredStyle: UIAlertControllerStyle = .alert) -> UIAlertController {
		return UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
	}
	
	public func ok(_ style: UIAlertActionStyle = .default, action inAction: (()->Void)? = nil) -> UIAlertController {
		return action(title: "OK".localized, style: style, action: inAction)
	}

	public func cancel(_ style: UIAlertActionStyle = .cancel, inAction: (()->Void)? = nil) -> UIAlertController {
		return action(title: "Cancel".localized, style: style, action: inAction)
	}
	
	public func action(title: String?, style: UIAlertActionStyle = .default, action: (()->Void)? = nil) -> UIAlertController {
		addAction(UIAlertAction(title: title, style: style) { _ in
			action?()
		})
		return self
	}
	
	@discardableResult public func show(_ viewController: UIViewController? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> UIAlertController {
		(viewController ?? visibleViewController())?.present(self, animated: animated, completion: completion)
			return self
	}
}

public func visibleViewController() -> UIViewController? {
	return UIApplication.shared.delegate?.window??.visibleViewController
}

public extension UIWindow {
    public var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }

    public static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
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
	public func makeTransparent(_ transparent: Bool)
	{
		setBackgroundImage(transparent ? UIImage() : nil, for: UIBarMetrics.default)
		shadowImage = transparent ? UIImage() : nil
	}
}

public extension Notification
{
	public var keyboardFrameEnd: CGRect?
	{
        if let info = (self as NSNotification).userInfo, let value = info[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            return value.cgRectValue
        } else {
            return nil
        }
    }
}

public extension UIView {

	public func findFirstResponder() -> UIView? {

		if isFirstResponder {
			return self
		}
		
		for subview in subviews {
			if let responder = subview.findFirstResponder() {
				return responder
			}
		}

		return nil
	}
}

public extension UIView {
	@discardableResult func add(to view: UIView) -> Self {
		view.addSubview(self)
		return self
	}

	@discardableResult func addArranged(to view: UIStackView) -> Self {
		view.addArrangedSubview(self)
		return self
	}

	
	@discardableResult func insert(in view: UIView, below: UIView) -> Self {
		view.insertSubview(self, belowSubview: below)
		return self
	}

	@discardableResult func insert(in view: UIView, above: UIView) -> Self {
		view.insertSubview(self, aboveSubview: above)
		return self
	}
	
	@discardableResult func insert(in view: UIView, atIndex index: Int) -> Self {
		view.insertSubview(self, at: index)
		return self
	}
}

public func printFontNames() {
	UIFont.familyNames.forEach {
		UIFont.fontNames(forFamilyName: $0).forEach {
			print($0)
		}
	}
}

public extension UIViewController {

	func dismissPresentedViewControllers() {
		presentedViewController?.dismiss(animated: false){
			self.dismissPresentedViewControllers()
		}
	}
}
