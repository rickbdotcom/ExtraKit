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

	@discardableResult func pin(edges: UIRectEdge = .all, to guide: UILayoutGuide? = nil, with insets: UIEdgeInsets = .zero, useSafeArea: Bool = false, alignWithLanguageDirection: Bool = false) -> [NSLayoutConstraint] {
		return pin(edges: edges, to: guide, with: insets)
	}
	
	@discardableResult func pin(edges: UIRectEdge = .all, to view: UIView? = nil, with insets: UIEdgeInsets = .zero, alignWithLanguageDirection: Bool = false) -> [NSLayoutConstraint] {
		return pin(edges: edges, to: view, with: insets)
	}

	@discardableResult func pin(edges: UIRectEdge = .all, to view: AnchorableObject? = nil, with insets: UIEdgeInsets = .zero, alignWithLanguageDirection: Bool = false) -> [NSLayoutConstraint] {
		translatesAutoresizingMaskIntoConstraints = false
		guard let pinToView = view ?? superview else {
			return []
		}

		var constraints = [NSLayoutConstraint]()
		if edges.contains(.top) {
 			constraints.append(pinToView.topAnchor.constraint(equalTo: topAnchor, constant: -insets.top))
		}
		if edges.contains(.left) {
			constraints.append(pinToView.xAxisStartAnchor(alignWithLanguageDirection: alignWithLanguageDirection).constraint(equalTo: xAxisStartAnchor(alignWithLanguageDirection: alignWithLanguageDirection), constant: -insets.left))
		}
		if edges.contains(.bottom) {
			constraints.append(pinToView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: insets.bottom))
		}
		if edges.contains(.right) {
			constraints.append(pinToView.xAxisEndAnchor(alignWithLanguageDirection: alignWithLanguageDirection).constraint(equalTo: xAxisEndAnchor(alignWithLanguageDirection: alignWithLanguageDirection), constant: insets.right))
		}
		constraints.forEach { $0.isActive = true }
		return constraints
	}

	@discardableResult func center(to view: UIView? = nil, offset: CGPoint = .zero) -> [NSLayoutConstraint] {
		translatesAutoresizingMaskIntoConstraints = false
		guard let centerToView = view ?? superview else {
			return []
		}
		var constraints = [NSLayoutConstraint]()
		constraints.append(centerToView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: offset.x))
		constraints.append(centerToView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: offset.y))

		constraints.forEach { $0.isActive = true }
		return constraints
	}
		
	@discardableResult func size(to size: CGSize) -> [NSLayoutConstraint] {
		var constraints = [NSLayoutConstraint]()
		constraints.append(widthAnchor.constraint(equalToConstant: size.width))
		constraints.append(heightAnchor.constraint(equalToConstant: size.height))
		constraints.forEach { $0.isActive = true } 		
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
