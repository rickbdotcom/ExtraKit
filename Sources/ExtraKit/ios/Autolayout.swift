import UIKit

extension UIView: AnchorableObject {
}

extension UILayoutGuide: AnchorableObject {
}

public protocol AnchorableObject {

    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

public extension AnchorableObject {
	
	func xAxisStartAnchor(alignWithLanguageDirection: Bool) -> NSLayoutXAxisAnchor {
		return alignWithLanguageDirection ? leadingAnchor : leftAnchor
	}

    func xAxisEndAnchor(alignWithLanguageDirection: Bool) -> NSLayoutXAxisAnchor {
        return alignWithLanguageDirection ? trailingAnchor : rightAnchor
    }
}
public extension UIView {

	@discardableResult func pin(edges: UIRectEdge = .all, to view: AnchorableObject? = nil, with insets: UIEdgeInsets = .zero, alignWithLanguageDirection: Bool = false, priority: UILayoutPriority = .required) -> Self {
		pinConstraints(edges: edges, to: view, with: insets, alignWithLanguageDirection: alignWithLanguageDirection, priority: priority)
		return self
	}

	@discardableResult func center(to view: UIView? = nil, offset: CGPoint = .zero, priority: UILayoutPriority = .required) -> Self {
		centerConstraints(to: view, offset: offset, priority: priority)
		return self
	}
	
	@discardableResult func size(to size: CGSize, priority: UILayoutPriority = .required) -> Self {
		sizeConstraints(to: size, priority: priority)
		return self
	}
	
	@discardableResult func aspectRatio(_ ratio: CGFloat, priority: UILayoutPriority = .required) -> Self {
		aspectRatioConstraint(ratio, priority: priority)
		return self
	}

	@discardableResult func aspectRatioConstraint(_ ratio: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
		let constraint = widthAnchor.constraint(equalTo: heightAnchor, multiplier: ratio).configure { $0.priority = priority }
		constraint.isActive = true
		return constraint
	}
	
	@discardableResult func pinConstraints(edges: UIRectEdge = .all, to view: AnchorableObject? = nil, with insets: UIEdgeInsets = .zero, alignWithLanguageDirection: Bool = false, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
		translatesAutoresizingMaskIntoConstraints = false
		guard let pinToView = view ?? superview else {
			return []
		}

		var constraints = [NSLayoutConstraint]()
		if edges.contains(.top) {
 			constraints.append(pinToView.topAnchor.constraint(equalTo: topAnchor, constant: -insets.top).configure { $0.priority = priority })
		}
		if edges.contains(.left) {
			constraints.append(pinToView.xAxisStartAnchor(alignWithLanguageDirection: alignWithLanguageDirection).constraint(equalTo: xAxisStartAnchor(alignWithLanguageDirection: alignWithLanguageDirection), constant: -insets.left).configure { $0.priority = priority })
		}
		if edges.contains(.bottom) {
			constraints.append(pinToView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: insets.bottom).configure { $0.priority = priority })
		}
		if edges.contains(.right) {
			constraints.append(pinToView.xAxisEndAnchor(alignWithLanguageDirection: alignWithLanguageDirection).constraint(equalTo: xAxisEndAnchor(alignWithLanguageDirection: alignWithLanguageDirection), constant: insets.right).configure { $0.priority = priority })
		}
		NSLayoutConstraint.activate(constraints)
		return constraints
	}

	@discardableResult func centerConstraints(to view: UIView? = nil, offset: CGPoint = .zero, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
		translatesAutoresizingMaskIntoConstraints = false
		guard let centerToView = view ?? superview else {
			return []
		}
		var constraints = [NSLayoutConstraint]()
		constraints.append(centerToView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: offset.x).configure { $0.priority = priority })
		constraints.append(centerToView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: offset.y).configure { $0.priority = priority })

		NSLayoutConstraint.activate(constraints)
		return constraints
	}
		
	@discardableResult func sizeConstraints(to size: CGSize, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
		var constraints = [NSLayoutConstraint]()
		constraints.append(widthAnchor.constraint(equalToConstant: size.width).configure { $0.priority = priority })
		constraints.append(heightAnchor.constraint(equalToConstant: size.height).configure { $0.priority = priority })
		NSLayoutConstraint.activate(constraints)
		return constraints
	}
}

class ScreenHeightProportionalConstraint: NSLayoutConstraint {
	
	@IBInspectable var screenReferenceHeight: CGFloat = 667
	
	override func awakeFromNib() {
		super.awakeFromNib()
		constant *= UIScreen.main.bounds.size.height / (screenReferenceHeight > 0 ? screenReferenceHeight : 667) 
	}
	
}
