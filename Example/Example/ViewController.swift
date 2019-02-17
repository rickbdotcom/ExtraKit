//
//  ViewController.swift
//  Example
//
//  Created by rickb on 2/17/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import ExtraKit

class ViewController: UIViewController, StoryboardSceneViewController {

	typealias Scene = StoryboardMain.Howdy

	@IBAction func next() {
		perform(segue: .showTable) { _ in
		}
	}
}

