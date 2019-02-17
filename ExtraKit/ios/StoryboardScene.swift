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
	associatedtype Segue: StoryboardSceneSegue

	var identifier: (String, String) { get }
	init()
}

public protocol StoryboardSceneSegue {
}

public protocol StoryboardSceneViewController {
	associatedtype Scene: StoryboardScene
}

public extension StoryboardScene {
	
	public func storyboard(bundle: Bundle? = nil) -> UIStoryboard {
		return UIStoryboard(name: identifier.1, bundle: bundle)
	}
		
	public func instantiate(bundle: Bundle? = nil) -> StoryboardClass {
		return storyboard(bundle: bundle).instantiateViewController(withIdentifier: identifier.0) as! StoryboardClass
	}
}

public extension StoryboardSceneViewController where Self: UIViewController, Scene.StoryboardClass == Self {

	public func perform<T: StoryboardSceneSegue>(segue: T, action: @escaping (UIStoryboardSegue) -> Void) where T: RawRepresentable, T.RawValue == String, T == Scene.Segue {
		performSegue(withIdentifier: segue.rawValue, action: action)
	}

	public static func instantiate(bundle: Bundle? = nil) -> Self {
		return Scene().instantiate(bundle: bundle)
	}
}
