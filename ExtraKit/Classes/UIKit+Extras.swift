import UIKit

public extension UIAlertController {

	class func alert(title: String? = nil, message: String? = nil, preferredStyle: UIAlertControllerStyle = .alert) -> UIAlertController {
		return UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
	}
	
	@discardableResult func ok(_ style: UIAlertActionStyle = .default, action inAction: (()->Void)? = nil) -> UIAlertController {
		return action(title: "OK".localized, style: style, action: inAction)
	}

	@discardableResult func cancel(_ style: UIAlertActionStyle = .cancel, inAction: (()->Void)? = nil) -> UIAlertController {
		return action(title: "Cancel".localized, style: style, action: inAction)
	}
	
	@discardableResult func action(title: String?, style: UIAlertActionStyle = .default, action: (()->Void)? = nil) -> UIAlertController {
		addAction(UIAlertAction(title: title, style: style) { _ in
			action?()
		})
		return self
	}
	
	@discardableResult func show(_ viewController: UIViewController? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> UIAlertController {
		(viewController ?? UIApplication.visibleViewController())?.present(self, animated: animated, completion: completion)
			return self
	}
}

public extension UIApplication {

	class func visibleViewController() -> UIViewController? {
		return shared.delegate?.window??.visibleViewController
	}
}

public extension UIWindow {

    var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }

    class func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
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

public extension Notification {

	var keyboardFrameEnd: CGRect?
	{
        if let info = (self as NSNotification).userInfo, let value = info[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            return value.cgRectValue
        } else {
            return nil
        }
    }
}

public extension UIView {

	func findFirstResponder() -> UIView? {

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

	@discardableResult func insertArranged(in view: UIStackView, at index: Int) -> Self {
		view.insertArrangedSubview(view, at: index)
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

public extension UIFont {

	class func printFontNames() {
		familyNames.forEach {
			fontNames(forFamilyName: $0).forEach {
				print($0)
			}
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
		return childViewControllers.first(where: { $0 is T }) as? T
	}
}

public extension UIView {

	func typedSuperview<T>() -> T? {
		return self as? T ?? superview?.typedSuperview()
	}

	func typedParentViewController<T>() -> T? {
		return self as? T ?? parentViewController?.typedParentViewController()
	}
	
	func typedSubview<T>() -> T? {
		return subviews.first(where: { $0 is T }) as? T
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

public extension UIViewController {
	
	func withNavigationController(_ navbarHidden: Bool = false) -> UINavigationController {
		return UINavigationController(rootViewController: self).configure {
			$0.isNavigationBarHidden = navbarHidden
		}
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
	
	@IBInspectable var cornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		set {
			layer.masksToBounds = true
			layer.cornerRadius = newValue
		}
	}
}

public extension UITableView {

	func update(_ update:(Void)->Void, animated: Bool) {
		UIView.setAnimationsEnabled(animated)
		beginUpdates()
		update()
		endUpdates()
		UIView.setAnimationsEnabled(true)
	}
}
