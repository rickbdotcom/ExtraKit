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

	@IBOutlet var imageView: UIImageView?
	@IBOutlet var button: UIButton?
	@IBOutlet var label: UILabel?
	
	typealias Scene = StoryboardMain.Howdy

	override func viewDidLoad() {
		super.viewDidLoad()
		imageView?.image = .lenna

		label?.text = String.things.localizedFormat(arc4random_uniform(5))
		label?.font = .fontMarathon(ofSize: 12.0)

		button?.setTitle(.hello, for: .normal)
		button?.titleLabel?.font = .fontMarathonII(ofSize: 13.0)
		button?.backgroundColor = .biv
	}

	@IBAction func next() {
		let aFoobar = Foobar()
		perform(segue: .showTable) { segue in
			segue.destination.inject(value: aFoobar)
		}
	}
}

class FoobarTableViewController: UITableViewController, FoobarContainer {
	var foobar: Foobar?
}
