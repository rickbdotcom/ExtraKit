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

	@discardableResult
	func addArranged(to view: UIStackView) -> Self {
		view.addArrangedSubview(self)
		return self
	}

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

public extension String {

    func label() -> UILabel {
        return UILabel().configure {
            $0.text = self
        }
    }
}

public extension UIImage {

    func imageView() -> UIImageView {
      return UIImageView(image: self).hugging(.defaultHigh).contentMode(.center)
    }
}

public func HStack(_ views: [UIView] = []) -> UIStackView {
    return UIStackView(arrangedSubviews: views).configure {
		$0.axis = .horizontal
	}
}

public func VStack(_ views: [UIView] = []) -> UIStackView {
	return UIStackView(arrangedSubviews: views).configure {
		$0.axis = .vertical
	}
}
