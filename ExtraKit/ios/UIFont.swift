//
//  UIFont.swift
//  ExtraKit
//
//  Created by rickb on 4/18/16.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

import UIKit

public extension UIFont {

	class func printFontNames() {
		familyNames.forEach {
			fontNames(forFamilyName: $0).forEach {
				print($0)
			}
		}
	}
}

public protocol FontRepresentable {
	func font(size: CGFloat) -> UIFont?
}


public extension FontRepresentable where Self: RawRepresentable, Self.RawValue == String {

	func font(size: CGFloat) -> UIFont? {
		return UIFont(name: rawValue, size: size)
	}
}
