//
//  AppDelegate.swift
//  Example
//
//  Created by rickb on 2/17/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import ExtraKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		UIViewController.usePrepareForSegueAction()
		UIView.useCapsuleCorners()
		UIView.useClearBackground()
		UILabel.useContentInsets()
		
		UIFont.printFontNames()
		print(String.hello)

		(0..<10).forEach {
			print(String.things.localizedFormat($0))
		}
		print(UIFont.fontMarathon(ofSize: 12.0))
		print(nibView.instantiate())
		print(ViewController.instantiate())
		
		return true
	}
}

protocol FoobarContainer: class  {
	var foobar: Foobar? { get set }
}

struct Foobar: Injectable {
	typealias Container = FoobarContainer
	static var containerKeyPath: ContainerKeyPath { return \Container.foobar }
}
