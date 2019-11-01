//
//  
//  ExtraKit
//
//  Created by rickb on 4/18/16.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

import Foundation
import UIKit

public class StackViewWithDividers: UIStackView {

    @IBInspectable public var dividerColor: UIColor = .lightGray { didSet { insertDividers() } }
    @IBInspectable public var dividerHeight: CGFloat = 1 { didSet { insertDividers() } }
    @IBInspectable public var dividerLeftInset: CGFloat = 0 { didSet { insertDividers() } }
    @IBInspectable public var dividerRightInset: CGFloat = 0 { didSet { insertDividers() } }
    @IBInspectable public var showTopDivider: Bool = false { didSet { insertDividers() } }
    @IBInspectable public var showBottomDivider: Bool = false { didSet { insertDividers() } }

    private var dividerInsets: UIEdgeInsets { return UIEdgeInsets(top: 0, left: dividerLeftInset, bottom: 0, right: dividerRightInset) }
    private var dividers = [UIView]()

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
            let divider = newDivider()
            divider.centerYAnchor.constraint(equalTo: firstView.topAnchor).isActive = true
        }
        Array(visibleArrangedSubviews.dropLast()).forEach { subview in
            let divider = newDivider()
            var spacing = self.spacing
            if #available(iOS 11.0, *) {
                let customSpacing = self.customSpacing(after: subview)
                if customSpacing != UIStackView.spacingUseDefault {
                    spacing = customSpacing
                }
            }
            divider.centerYAnchor.constraint(equalTo: subview.bottomAnchor, constant: spacing * 0.5).isActive = true
        }
        if showBottomDivider, let lastView = visibleArrangedSubviews.last {
            let divider = newDivider()
            divider.centerYAnchor.constraint(equalTo: lastView.bottomAnchor).isActive = true
        }
    }

    func newDivider() -> UIView {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        addSubview(divider)
        divider.backgroundColor = dividerColor
        divider.isUserInteractionEnabled = false
        divider.heightAnchor.constraint(equalToConstant: dividerHeight).isActive = true
        divider.leftAnchor.constraint(equalTo: leftAnchor, constant: dividerLeftInset).isActive = true
        divider.rightAnchor.constraint(equalTo: rightAnchor, constant: -dividerRightInset).isActive = true
        dividers.append(divider)
        return divider
    }
}
