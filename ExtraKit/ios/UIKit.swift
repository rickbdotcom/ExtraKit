import UIKit

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

public extension UIViewController {

	func dismissPresentedViewControllers(_ completion: (()->Void)? = nil) {
		if let presentedViewController = presentedViewController {
			presentedViewController.dismiss(animated: false){
				self.dismissPresentedViewControllers(completion)
			}
		} else {
			completion?()
		}
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

	@IBInspectable var borderWidth: CGFloat {
		get {
			return layer.borderWidth
		}
		set {
			layer.borderWidth = newValue
		}
	}
}

public extension UITextField {

	@IBOutlet var leftViewOutlet: UIView? {
		get { return leftView }
		set { leftView = newValue; leftViewMode = .always }
	}

	@IBOutlet var rightViewOutlet: UIView? {
		get { return rightView }
		set { rightView = newValue; rightViewMode = .always }
	}
	
	@IBInspectable var leftImage: UIImage? {
		get {
			return (leftView as? UIImageView)?.image
		}
		set {
			var imageView = rightView as? UIImageView
			if imageView == nil {
				imageView = UIImageView()
				leftViewMode = .always
				leftView = imageView 
			}
			imageView?.image = newValue
			imageView?.bounds.size = newValue?.size ?? .zero
		}
	} 
	
	@IBInspectable var rightImage: UIImage? {
		get {
			return (rightView as? UIImageView)?.image
		}
		set {
			var imageView = rightView as? UIImageView
			if imageView == nil {
				imageView = UIImageView()
				rightViewMode = .always
				rightView = imageView
			}
			imageView?.image = newValue
			imageView?.bounds.size = newValue?.size ?? .zero
		}
	}

	class func useContentInsets() {
		swizzle(instanceMethod: #selector(textRect(forBounds:)), with: #selector(textRectWithContentInsets(forBounds:)))
		swizzle(instanceMethod: #selector(leftViewRect(forBounds:)), with: #selector(leftViewRectWithContentInsets(forBounds:)))
		swizzle(instanceMethod: #selector(rightViewRect(forBounds:)), with: #selector(rightViewRectWithContentInsets(forBounds:)))
	}	

    @objc func textRectWithContentInsets(forBounds bounds: CGRect) -> CGRect {
		return textRectWithContentInsets(forBounds: UIEdgeInsetsInsetRect(bounds, contentInsets))
	}
	
	@objc func leftViewRectWithContentInsets(forBounds bounds: CGRect) -> CGRect {
		return leftViewRectWithContentInsets(forBounds: UIEdgeInsetsInsetRect(bounds, contentInsets))
	}

    @objc func rightViewRectWithContentInsets(forBounds bounds: CGRect) -> CGRect {
		return rightViewRectWithContentInsets(forBounds: UIEdgeInsetsInsetRect(bounds, contentInsets))
	}
}

public extension UILabel {
	
	class func useContentInsets() {
		swizzle(instanceMethod:#selector(getter: intrinsicContentSize), with: #selector(intrinsicContentSizeWithContentInsets))
		swizzle(instanceMethod:#selector(drawText(in:)), with: #selector(drawTextWithContentInsets(in:)))
	}

	@objc func drawTextWithContentInsets(in rect: CGRect) {
        drawTextWithContentInsets(in: UIEdgeInsetsInsetRect(rect, contentInsets))
    }

	@objc func intrinsicContentSizeWithContentInsets() -> CGSize {
		var size = intrinsicContentSizeWithContentInsets()
        size.height += contentInsets.top + contentInsets.bottom 
        size.width += contentInsets.left + contentInsets.right
		return size
	}
}

public extension UIView {

	@IBInspectable var contentInsetsString: String? {
		get { return NSStringFromUIEdgeInsets(contentInsets) }
		set { contentInsets = UIEdgeInsetsFromString(newValue ?? "") }
	}
	
	var contentInsets: UIEdgeInsets {
		get { 
			return associatedValue() ?? .zero 
		}
		set { 
			set(associatedValue: newValue) 
			invalidateIntrinsicContentSize()
		}
	}
}

public extension UIView {

	@IBOutlet weak var containerView: UIView? {
		get { return weakAssociatedValue() ?? self }
		set { set(weakAssociatedValue: newValue) }
	}
}

public extension UIEdgeInsets {

	init(top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil) {
		self.top = top ?? 0; self.left = left ?? 0; self.bottom = bottom ?? 0; self.right = right ?? 0;
	}
	
	init(_ inset: CGFloat) {
		self.top = inset; self.left = inset; self.bottom = inset; self.right = inset;	
	}
}

public extension CGRect {

	func inset(by insets: UIEdgeInsets) -> CGRect {
		return UIEdgeInsetsInsetRect(self, insets)
	}
}

public extension UIView {

	@discardableResult func pin(edges: UIRectEdge = .all, to view: UIView? = nil, with insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
		translatesAutoresizingMaskIntoConstraints = false
		guard let pinToView = view ?? superview else {
			return []
		}
		var constraints = [NSLayoutConstraint]()
		if edges.contains(.top) {
 			constraints.append(pinToView.topAnchor.constraint(equalTo: topAnchor, constant: -insets.top))
		}
		if edges.contains(.left) {
			constraints.append(pinToView.leftAnchor.constraint(equalTo: leftAnchor, constant: -insets.left))
		}
		if edges.contains(.bottom) {
			constraints.append(pinToView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: insets.bottom))
		}
		if edges.contains(.right) {
			constraints.append(pinToView.rightAnchor.constraint(equalTo: rightAnchor, constant: insets.right))
		}
		constraints.forEach { $0.isActive = true }
		return constraints
	}
}

public extension UINib {
	static func instantiate<T>(_ nibName: String, bundle: Bundle? = nil) -> T? {
		return UINib(nibName: nibName, bundle: bundle).instantiate(withOwner: nil, options: nil).first as? T
	}
}

