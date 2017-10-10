import UIKit

public extension UIAlertController {

	class func alert(title: String? = nil, message: String? = nil, preferredStyle: UIAlertControllerStyle = .alert) -> UIAlertController {
		return UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
	}
	
	@discardableResult func ok(_ style: UIAlertActionStyle = .default, action inAction: ((UIAlertController)->Void)? = nil) -> Self {
		return action(title: "OK".localized(), style: style, action: inAction)
	} 

	@discardableResult func cancel(_ style: UIAlertActionStyle = .cancel, inAction: ((UIAlertController)->Void)? = nil) -> Self {
		return action(title: "Cancel".localized(), style: style, action: inAction)
	}
	
	@discardableResult func action(title: String?, style: UIAlertActionStyle = .default, action: ((UIAlertController)->Void)? = nil) -> Self {
		addAction(UIAlertAction(title: title, style: style) { _ in
			action?(self)
		})
		return self
	}

	@discardableResult func textField(configurationHandler: ((UITextField) -> Void)? = nil) -> Self {
		addTextField(configurationHandler: configurationHandler)
		return self
	}

	@discardableResult func show(_ viewController: UIViewController? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> Self {
		(viewController ?? rootWindow?.visibleViewController)?.present(self, animated: animated, completion: completion)
			return self
	}

	class func set(rootWindow window: UIWindow?) {
		rootWindow = window
	}
}

fileprivate weak var rootWindow: UIWindow?

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

public protocol FontRepresentable {
	func font(size: CGFloat) -> UIFont?
}


public extension FontRepresentable where Self: RawRepresentable, Self.RawValue == String {

	func font(size: CGFloat) -> UIFont? {
		return UIFont(name: rawValue, size: size)
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
		swizzle(#selector(getter: intrinsicContentSize), newSelector: #selector(intrinsicContentSizeWithContentInsets))
		swizzle(#selector(textRect(forBounds:)), newSelector: #selector(textRectWithContentInsets(forBounds:)))
		swizzle(#selector(editingRect(forBounds:)), newSelector: #selector(editingRectWithContentInsets(forBounds:)))
		swizzle(#selector(drawText(in:)), newSelector: #selector(drawTextWithContentInsets(in:)))
	}	

    @objc func drawTextWithContentInsets(in rect: CGRect) {
		return drawTextWithContentInsets(in: UIEdgeInsetsInsetRect(rect, contentInsets))
    }

    @objc func editingRectWithContentInsets(forBounds bounds: CGRect) -> CGRect {
		return editingRectWithContentInsets(forBounds: UIEdgeInsetsInsetRect(bounds, contentInsets))    
	}

    @objc func textRectWithContentInsets(forBounds bounds: CGRect) -> CGRect {
		return textRectWithContentInsets(forBounds: UIEdgeInsetsInsetRect(bounds, contentInsets))
	}

// wtf
	@objc func _useShortcutIntrinsicContentSize() -> Bool {
		return false
	}
// wtf	
	@objc func numberOfLines() -> Int {
		return 1
	}
}

public extension UILabel {
	
	class func useContentInsets() {
		swizzle(#selector(getter: intrinsicContentSize), newSelector: #selector(intrinsicContentSizeWithContentInsets))
		swizzle(#selector(drawText(in:)), newSelector: #selector(drawTextWithContentInsets(in:)))
	}

	@objc func drawTextWithContentInsets(in rect: CGRect) {
        drawTextWithContentInsets(in: UIEdgeInsetsInsetRect(rect, contentInsets))
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

	@objc func intrinsicContentSizeWithContentInsets() -> CGSize {
		var size = intrinsicContentSizeWithContentInsets()
        size.height += contentInsets.top + contentInsets.bottom 
        size.width += contentInsets.left + contentInsets.right
		return size
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
}

public extension CGRect {

	func inset(by insets: UIEdgeInsets) -> CGRect {
		return UIEdgeInsetsInsetRect(self, insets)
	}
}

public extension UIView {

	func pinEdgesToSuperview() -> Self {
		superview?.topAnchor.constraint(equalTo: topAnchor).isActive = true
		superview?.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		superview?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		superview?.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		return self
	}
}

public extension UINib {
	static func instantiate<T>(_ nibName: String, bundle: Bundle? = nil) -> T? {
		return UINib(nibName: nibName, bundle: bundle).instantiate(withOwner: nil, options: nil).first as? T
	}
}

public protocol AllValues {
	static var all: [Self] { get }
}

public protocol DisplayName {
	var displayName: String { get }
}

public protocol AllValuesPicker {

	func populateValues<T: AllValues & DisplayName>(_ type: T.Type, allowsUnselected: Bool)
	func selectedValue<T: AllValues>() -> T?
	func select<T: AllValues & Equatable>(value: T?)
}

public extension RawRepresentable where Self: DisplayName, RawValue == String {

	var displayName: String {
		return rawValue.capitalized
	}
}

extension UISegmentedControl: AllValuesPicker {

	public func populateValues<T: AllValues & DisplayName>(_ type: T.Type, allowsUnselected: Bool = false) {
		removeAllSegments()
		type.all.reversed().forEach {
			insertSegment(withTitle: $0.displayName, at: 0, animated: false)
		}
	}
	
	public func selectedValue<T: AllValues>() -> T? {
		return (0..<T.all.count).contains(selectedSegmentIndex) ? T.all[selectedSegmentIndex] : nil
	}
	
	public func select<T: AllValues & Equatable>(value: T?) {
		selectedSegmentIndex = value.flatMap { T.all.index(of: $0) } ?? UISegmentedControlNoSegment
	}
}
