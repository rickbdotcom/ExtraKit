//
//  StackViewWithDividers.swift
//  ExtraKit
//
//  Created by rickb on 6/29/19.
//  Copyright © 2019 rickbdotcom LLC. All rights reserved.
//

import ExtraKitCore
import UIKit

public class StackViewWithDividers: UIStackView {

    @IBInspectable var dividerColor: UIColor = .lightGray { didSet { setNeedsLayout() } }
    @IBInspectable var dividerHeight: CGFloat = 1.0 { didSet { setNeedsLayout() } }
    @IBInspectable var showTopDivider: Bool = false { didSet { setNeedsLayout() } }
    @IBInspectable var showBottomDivider: Bool = false { didSet { setNeedsLayout() } }

    var dividerInsets: UIEdgeInsets = .zero
    private var insertingDividers = false

    private func insertDividers() {
        arrangedSubviews.filter { $0 is StackViewDivider }.forEach { $0.removeFromSuperview() }
        let arrangedViews = arrangedSubviews.filter { $0.isHidden == false }

        if showTopDivider && arrangedViews.isEmpty == false {
            insertArrangedSubview(StackViewDivider(height: dividerHeight, color: dividerColor, insets: dividerInsets), at: 0)
        }
        Array(arrangedViews.dropLast()).forEach { subview in
            insertArrangedSubview(StackViewDivider(height: dividerHeight, color: dividerColor, insets: dividerInsets), at: arrangedSubviews.firstIndex(of: subview)! + 1) // swiftlint:disable:this force_unwrapping
        }
        if showBottomDivider && arrangedViews.isEmpty == false {
            insertArrangedSubview(StackViewDivider(height: dividerHeight, color: dividerColor, insets: dividerInsets), at: arrangedSubviews.count)
        }
    }

	override public func layoutSubviews() {
        super.layoutSubviews()
        if insertingDividers == false {
            insertingDividers = true
            insertDividers()
        } else {
            insertingDividers = false
        }
    }
}

public class StackViewDivider: UIView {

    convenience init(height: CGFloat = 1, color: UIColor = .lightGray, insets: UIEdgeInsets = .zero) {
        self.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        UIView().configure { $0.backgroundColor = color }.add(to: self).height(height).pin(with: insets)
    }
}

func DivStack(_ views: [UIView] = [], top: Bool = false, bottom: Bool = false) -> UIStackView {
	return StackViewWithDividers(arrangedSubviews: views).configure {
		$0.axis = .vertical
		$0.showTopDivider = top
		$0.showBottomDivider = bottom
	}
}
