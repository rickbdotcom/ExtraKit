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
