//
//  StoryboardScene.swift
//  ExtraKit
//
//  Created by rickb on 4/18/16.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

import UIKit

public protocol StoryboardScene {

	associatedtype StoryboardClass
	
	var identifier: (String, String) { get }
}

public extension StoryboardScene {
	
	public func storyboard(bundle: Bundle? = nil) -> UIStoryboard {
		return UIStoryboard(name: identifier.1, bundle: bundle)
	}
		
	public func instantiate(bundle: Bundle? = nil) -> StoryboardClass {
		return storyboard(bundle: bundle).instantiateViewController(withIdentifier: identifier.0) as! StoryboardClass
	}
}
