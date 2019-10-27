//
//  
//  ExtraKit
//
//  Created by rickb on 4/18/16.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

import ExtraKitCore
import UIKit

public class StackViewWithDividers: UIStackView {

    @IBInspectable public var dividerColor: UIColor = .lightGray { didSet { insertDividers() } }
    @IBInspectable public var dividerHeight: CGFloat = 0.5 { didSet { insertDividers() } }
    @IBInspectable public var showTopDivider: Bool = false { didSet { insertDividers() } }
    @IBInspectable public var showBottomDivider: Bool = false { didSet { insertDividers() } }
	@IBInspectable public var dividerInsetString: String? {
		set {
			dividerInsets = NSCoder.uiEdgeInsets(for: newValue ?? "")
			insertDividers()
		}
		get {
			return NSCoder.string(for: dividerInsets)
		}
	}
    public var dividerInsets: UIEdgeInsets = .zero
	private var dividers = [StackViewDivider]()

	override public func awakeFromNib() {
		super.awakeFromNib()
		insertDividers()
	}
	override public func addArrangedSubview(_ view: UIView) {
		super.addArrangedSubview(view)
		insertDividers()
	}

	override public func removeArrangedSubview(_ view: UIView) {
		super.removeArrangedSubview(view)
	}

	override public func insertArrangedSubview(_ view: UIView, at stackIndex: Int) {
		super.insertArrangedSubview(view, at: stackIndex)
	}

    private func insertDividers() {
        dividers.forEach { $0.removeFromSuperview() }
        let visibleArrangedSubviews = arrangedSubviews.filter { $0.isHidden == false }

        if showTopDivider, let firstView = visibleArrangedSubviews.first {
			dividers.append(StackViewDivider(height: dividerHeight, color: dividerColor, insets: dividerInsets).add(to: self).pin(edges: [.top, .left, .right], to: firstView, with: UIEdgeInsets(top: -dividerHeight * 0.5)))
        }
        Array(visibleArrangedSubviews.dropLast()).forEach { subview in
			dividers.append(StackViewDivider(height: dividerHeight, color: dividerColor, insets: dividerInsets).add(to: self).pin(edges: [.bottom, .left, .right], to: subview, with: UIEdgeInsets(bottom: -dividerHeight * 0.5)))
        }
        if showBottomDivider, let lastView = visibleArrangedSubviews.last {
			dividers.append(StackViewDivider(height: dividerHeight, color: dividerColor, insets: dividerInsets).add(to: self).pin(edges: [.bottom, .left, .right], to: lastView, with: UIEdgeInsets(bottom: -dividerHeight * 0.5)))
        }
    }
}

public extension StackViewWithDividers {

	@discardableResult
    func dividerColor(_ color: UIColor) -> Self {
		dividerColor = color
		return self
	}

	@discardableResult
    func dividerHeight(_ height: CGFloat) -> Self {
		dividerHeight = height
		return self
	}

	@discardableResult
    func showTopDivider(_ show: Bool) -> Self {
		showTopDivider = show
		return self
	}

	@discardableResult
    func showBottomDivider(_ show: Bool) -> Self {
		showBottomDivider = show
		return self
	}
}

private class StackViewDivider: UIView {

    convenience init(height: CGFloat, color: UIColor, insets: UIEdgeInsets) {
        self.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        UIView().configure { $0.backgroundColor = color }.add(to: self).height(height).pin(with: insets)
    }
}
