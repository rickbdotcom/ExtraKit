//
//  FluentUI.swift
//  ExtraKit
//
//  Created by rickb on 8/16/19.
//  Copyright © 2019 rickbdotcom LLC. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {

	@discardableResult
	func add(to view: UIView) -> Self {
		view.addSubview(self)
		return self
	}

	@available(iOS 9.0, *)
	@discardableResult
	func addArranged(to view: UIStackView) -> Self {
		view.addArrangedSubview(self)
		return self
	}

	@available(iOS 9.0, *)
	@discardableResult
	func insertArranged(in view: UIStackView, at index: Int) -> Self {
		view.insertArrangedSubview(view, at: index)
		return self
	}

	@discardableResult
	func insert(in view: UIView, below: UIView) -> Self {
		view.insertSubview(self, belowSubview: below)
		return self
	}

	@discardableResult
	func insert(in view: UIView, above: UIView) -> Self {
		view.insertSubview(self, aboveSubview: above)
		return self
	}

	@discardableResult
	func insert(in view: UIView, atIndex index: Int) -> Self {
		view.insertSubview(self, at: index)
		return self
	}

	@discardableResult
	func bringToFront() -> Self {
		superview?.bringSubviewToFront(self)
		return self
	}

	@discardableResult
	func sendToBack() -> Self {
		superview?.sendSubviewToBack(self)
		return self
	}

    @discardableResult
    func userInteraction(_ enabled: Bool) -> Self {
        isUserInteractionEnabled = enabled
        return self
    }

    @discardableResult
    func contentMode(_ mode: UIView.ContentMode) -> Self {
        contentMode = mode
        return self
    }

    @discardableResult
    func hugging(_ priority: UILayoutPriority) -> Self {
        setContentHuggingPriority(priority, for: .horizontal)
        return self
    }

    @discardableResult
    func padding(_ inset: UIEdgeInsets) -> UIView {
        return HStack([self]).margins(inset)
    }

	@discardableResult
	func backgroundColor(_ color: UIColor) -> Self {
		self.backgroundColor = color
		return self
	}

	@discardableResult
	func cornerRadius(_ radius: CGFloat) -> Self {
		layer.cornerRadius = radius
		return self
	}

	@discardableResult
	func borderWidth(_ width: CGFloat) -> Self {
		layer.borderWidth = width
		return self
	}

	@discardableResult
	func borderColor(_ color: UIColor) -> Self {
		layer.borderColor = color.cgColor
		return self
	}

	@discardableResult
	func tint(_ color: UIColor) -> Self {
		tintColor = color
		return self
	}
}

public extension UILabel {

	@discardableResult
	func textColor(_ color: UIColor) -> Self {
		textColor = color
		return self
	}
}

public extension UITextField {

	@discardableResult
	func textColor(_ color: UIColor) -> Self {
		textColor = color
		return self
	}
}

public extension UIButton {

	@discardableResult
	func titleColor(_ color: UIColor, for: UIControl.State = .normal) -> Self {
		setTitleColor(color, for: .normal)
		return self
	}
}

extension UIStackView {

    func removeAllArrangedViews() {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    @discardableResult
    func spacing(_ spacing: CGFloat) -> Self {
        self.spacing = spacing
        return self
    }

	@discardableResult
    func margins(_ inset: UIEdgeInsets) -> Self {
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = inset
        return self
    }

	@discardableResult
    func align(_ alignment: UIStackView.Alignment) -> Self {
        self.alignment = alignment
        return self
    }

    @discardableResult
    func distribution(_ distribution: UIStackView.Distribution) -> Self {
		self.distribution = distribution
		return self
	}
}

extension String {

    func label() -> UILabel {
        return UILabel().configure {
            $0.text = self
        }
    }
}

extension UIImage {

    func imageView() -> UIImageView {
      return UIImageView(image: self).hugging(.defaultHigh).contentMode(.center)
    }
}

func HStack(_ views: [UIView] = []) -> UIStackView {
    let stackView = UIStackView(arrangedSubviews: views)
    stackView.axis = .horizontal
    return stackView
}

func VStack(_ views: [UIView] = [], withDividers: Bool = false, showTopDivider: Bool = false, showBottomDivider: Bool = false) -> UIStackView {
    if withDividers || showTopDivider || showBottomDivider {
        let stackView = StackViewWithDividers(arrangedSubviews: views)
        stackView.axis = .vertical
        stackView.showTopDivider = showTopDivider
        stackView.showBottomDivider = showBottomDivider
        return stackView
    } else {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .vertical
        return stackView
    }
}
