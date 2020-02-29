import UIKit

public extension UIViewController {

	func parentViewController<T>(ofType: T.Type = T.self) -> T? {
		self as? T ?? parent?.parentViewController()
	}
	
	func childViewController<T>(ofType: T.Type = T.self) -> T? {
		children.first(where: { $0 is T }) as? T
	}
}

public extension UIView {

    func superview<T>(ofType: T.Type = T.self) -> T? {
        self as? T ?? superview?.superview()
    }

    func parentViewController<T>(ofType: T.Type = T.self) -> T? {
        self as? T ?? parentViewController?.parentViewController()
    }

    func subview<T>(ofType: T.Type = T.self) -> T? {
		subviews.first { $0 is T } as? T
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

public extension UIEdgeInsets {

	init(top: CGFloat? = nil, left: CGFloat? = nil, bottom: CGFloat? = nil, right: CGFloat? = nil) {
		self.init(top: top ?? 0, left: left ?? 0, bottom: bottom ?? 0, right: right ?? 0)
	}
	
	init(_ inset: CGFloat) {
		self.init(top: inset, left: inset, bottom: inset, right: inset)
	}
}
