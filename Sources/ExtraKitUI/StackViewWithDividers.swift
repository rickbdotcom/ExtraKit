//
//  
//  ExtraKit
//
//  Created by rickb on 4/18/16.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

import ExtraKitCore
import UIKit

class StackViewWithDividers: UIStackView {

    @IBInspectable var dividerColor: UIColor = .lightGray { didSet { insertDividers() } }
    @IBInspectable var dividerHeight: CGFloat = 0.5 { didSet { insertDividers() } }
    @IBInspectable var showTopDivider: Bool = false { didSet { insertDividers() } }
    @IBInspectable var showBottomDivider: Bool = false { didSet { insertDividers() } }
	@IBInspectable var dividerInsetString: String? {
		set {
			dividerInsets = NSCoder.uiEdgeInsets(for: newValue ?? "")
			insertDividers()
		}
		get {
			return NSCoder.string(for: dividerInsets)
		}
	}
    var dividerInsets: UIEdgeInsets = .zero
	private var dividers = [StackViewDivider]()

	override func awakeFromNib() {
		super.awakeFromNib()
		insertDividers()
	}
	override func addArrangedSubview(_ view: UIView) {
		super.addArrangedSubview(view)
		insertDividers()
	}

    override func removeArrangedSubview(_ view: UIView) {
		super.removeArrangedSubview(view)
	}

    override func insertArrangedSubview(_ view: UIView, at stackIndex: Int) {
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

private class StackViewDivider: UIView {

    convenience init(height: CGFloat, color: UIColor, insets: UIEdgeInsets) {
        self.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        UIView().configure { $0.backgroundColor = color }.add(to: self).height(height).pin(with: insets)
    }
}
