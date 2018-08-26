//
//  StoryboardScene.swift
//  ExtraKit
//
//  Created by rickb on 4/18/16.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

import UIKit

public protocol ColorRepresentable {
	var color: UIColor? { get }
}

public extension ColorRepresentable where Self: RawRepresentable, Self.RawValue == String {

	var color: UIColor? {
		if #available(iOS 11.0, *) {
			return UIColor(named: rawValue)
		} else {
			return nil
		}
	}
}
