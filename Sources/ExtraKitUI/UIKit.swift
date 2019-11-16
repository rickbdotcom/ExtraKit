import UIKit

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
        return subviews.first { $0 is T } as? T
    }

    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
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
