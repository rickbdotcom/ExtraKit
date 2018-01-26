//
//  StoryboardScene.swift
//  ExtraKit
//
//  Created by rickb on 4/18/16.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

import UIKit

public protocol StoryboardScene {

	var identifier: (String, String) { get }
}

public extension StoryboardScene {
	
	public func storyboard(_ bundle: Bundle? = nil) -> UIStoryboard {
		return UIStoryboard(name: identifier.1, bundle: bundle)
	}
	
	public func instantiateViewController(_ bundle: Bundle? = nil) -> UIViewController {
		return storyboard(bundle).instantiateViewController(withIdentifier: identifier.0)
	}
}

