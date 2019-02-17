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
