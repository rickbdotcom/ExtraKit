import UIKit

public extension UIView {

	@discardableResult func add(to view: UIView) -> Self {
		view.addSubview(self)
		return self
	}

	@available(iOS 9.0, *)
	@discardableResult func addArranged(to view: UIStackView) -> Self {
		view.addArrangedSubview(self)
		return self
	}

	@available(iOS 9.0, *)
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
		superview?.bringSubviewToFront(self)
		return self
	}

	@discardableResult func sendToBack() -> Self {
		superview?.sendSubviewToBack(self)
		return self
	}
}

public extension UIViewController {

	func parentViewController<T>(ofType: T.Type) -> T? {
		return typedParentViewController()
	}
	
	func childViewController<T>(ofType: T.Type) -> T? {
		return typedChildViewController()
	}

	func typedParentViewController<T>() -> T? {
		return self as? T ?? parent?.typedParentViewController()
	}
	
	func typedChildViewController<T>() -> T? {
		return children.first(where: { $0 is T }) as? T
	}
}

public extension UIView {

	func superview<T>(ofType: T.Type) -> T? {
		return typedSuperview()
	}

	func parentViewController<T>(ofType: T.Type) -> T? {
		return typedParentViewController()
	}
	
	func subview<T>(ofType: T.Type) -> T? {
		return typedSubview()
	}
	
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
	
	@IBInspectable var maskedCornersString: String? {
		get {
			if #available(iOS 11.0, *) {
				return maskedCornerArray.map {
					layer.maskedCorners.contains($0) ? "true" : "false"
				}.joined(separator: " ")
			} else {
				return nil
			}
		}
		set {
			if #available(iOS 11.0, *) {
				if let boolArray = newValue?.components(separatedBy: " ").map({ $0 == "true" })
				, boolArray.count == 4 {
					layer.masksToBounds = true
					layer.maskedCorners = zip(maskedCornerArray, boolArray).reduce([]) {
						return $1.1 ? $0.union($1.0) : $0
					}
				} else {
					layer.maskedCorners = []
				}
			}
		}
	}
}

private let maskedCornerArray: [CACornerMask] = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]

public extension UIView {

	@IBOutlet weak var containerViewOrSelf: UIView! {
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
	
	@IBInspectable var onlyTestPassthroughViews: Bool {
		get { return associatedValue() ?? true }
		set { set(associatedValue: newValue) }	
	}

	class func usePassthroughViews() {
		swizzle(instanceMethod: #selector(passthrough_hitTest(_:with:)), with: #selector(hitTest(_:with:)))	
	}
	
    func addPassthroughView(_ view: UIView) {
        if passthroughViews == nil {
            passthroughViews = []
        }
        passthroughViews?.append(view)
    }

    func removePassthroughView(_ view: UIView) {
		if let index = passthroughViews?.firstIndex(of: view) {
            passthroughViews?.remove(at: index)
            if passthroughViews?.isEmpty ?? false {
                passthroughViews = nil
            }
        }
    }

	@objc func passthrough_hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		if let passthroughViews = passthroughViews {
			for view in passthroughViews {
				if let viewHit = view.hitTest(view.convert(point, from: self), with: event) {
					return viewHit
				}
			}
			return onlyTestPassthroughViews ? nil : passthrough_hitTest(point, with: event)
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

public extension UIView {
	
	@IBInspectable var stackViewCustomSpacing: Double {
		get { return associatedValue() ?? -Double.greatestFiniteMagnitude }
		set { set(associatedValue: newValue); setCustomSpacing() }
	}
	
	class func useStackViewCustomSpacing() {
		if #available(iOS 11.0, *) {
			swizzle(instanceMethod: #selector(didMoveToSuperview), with: #selector(stackViewCustomSpacing_didMoveToSuperview))
		}	
	}
	
	@objc func stackViewCustomSpacing_didMoveToSuperview() {
		stackViewCustomSpacing_didMoveToSuperview()
		setCustomSpacing()
	}
	
	func setCustomSpacing() {
		if #available(iOS 11.0, *)
		, stackViewCustomSpacing != -Double.greatestFiniteMagnitude
		, let parentStackView = superview as? UIStackView
		, parentStackView.arrangedSubviews.contains(self) {
			parentStackView.setCustomSpacing(CGFloat(stackViewCustomSpacing), after: self)
		}
	}
}
