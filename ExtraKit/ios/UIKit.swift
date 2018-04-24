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

	@discardableResult func bringToFront() -> Self {
		superview?.bringSubview(toFront: self)
		return self
	}

	@discardableResult func sendToBack() -> Self {
		superview?.sendSubview(toBack: self)
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
	
	@objc var contentInsets: UIEdgeInsets {
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
		self.init(top: top ?? 0, left: left ?? 0, bottom: bottom ?? 0, right: right ?? 0)
	}
	
	init(_ inset: CGFloat) {
		self.init(top: inset, left: inset, bottom: inset, right: inset)
	}
}

public extension CGRect {

	func inset(by insets: UIEdgeInsets) -> CGRect {
		return UIEdgeInsetsInsetRect(self, insets)
	}
}

public extension UIView {

	@IBInspectable var capsuleCorners: Bool {
		get { return associatedValue() ?? false }
		set {
			set(associatedValue: newValue)
			setNeedsLayout()
			if newValue == false {
				cornerRadius = 0
			}
		}
	}

	class func useCapsuleCorners() {
		swizzle(instanceMethod: #selector(layoutSubviews), with: #selector(capsuleCorners_layoutSubviews))
		UIButton.useCapsuleCornersForButton()
	}
		
	@objc func capsuleCorners_layoutSubviews() {
		capsuleCorners_layoutSubviews()
		if capsuleCorners {
			cornerRadius = bounds.size.height / 2.0
		}
	}
}

public extension UIButton {

// this shouldn't be necessary but probably something to do with either UIButton being implemented as a class cluster or it not calling super layout method
	class func useCapsuleCornersForButton() {
		swizzle(instanceMethod: #selector(layoutSubviews), with: #selector(buttonCapsuleCorners_layoutSubviews))
	}

	@objc func buttonCapsuleCorners_layoutSubviews() {
		buttonCapsuleCorners_layoutSubviews()
		if capsuleCorners {
			cornerRadius = bounds.size.height / 2.0
		}
	}
}

public extension UIView {

	@IBOutlet var passthroughViews: [UIView]? {
		get { return associatedValue() }
		set { set(associatedValue: newValue) }
	}

	class func usePassthroughViews() {
		swizzle(instanceMethod: #selector(passthrough_hitTest(_:with:)), with: #selector(hitTest(_:with:)))	
	}
	
	@objc func passthrough_hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		if let passthroughViews = passthroughViews {
			for view in passthroughViews {
				if let viewHit = view.hitTest(view.convert(point, from: self), with: event) {
					return viewHit
				}
			}
			return nil
		}
		return passthrough_hitTest(point, with: event)
	}
}

public extension UIView {

	@IBInspectable var clearBackground: Bool {
		get { return associatedValue() ?? false }
		set { set(associatedValue: newValue) }
	}
	
	class func useClearBackground() {
		swizzle(instanceMethod: #selector(awakeFromNib), with: #selector(clearBackground_awakeFromNib))
	}
	
	@objc func clearBackground_awakeFromNib() {
		clearBackground_awakeFromNib()
		if clearBackground {
			backgroundColor = .clear
		}
	}
}

public extension UIStackView {

	class func useMultiLineLabelFix() {
		swizzle(instanceMethod: #selector(layoutSubviews), with: #selector(multiLineLabelFix_layoutSubviews))
	}
	
	@objc func multiLineLabelFix_layoutSubviews() {
		multiLineLabelFix_layoutSubviews()
		arrangedSubviews.compactMap { $0 as? UILabel }.filter { 
			$0.numberOfLines == 0 && $0.preferredMaxLayoutWidth != $0.bounds.size.width 
		}.forEach { 
			$0.preferredMaxLayoutWidth = $0.bounds.size.width
			setNeedsLayout()
		}
	}
}
