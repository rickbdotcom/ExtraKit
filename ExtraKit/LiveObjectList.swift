import Foundation
import UIKit

class LiveObjectList {

	static let sharedInstance = LiveObjectList()
	
	var keepReleasedObjects = false
	
	var objects = [WeakRef]()
	
	var liveObjects: [WeakRef] {
		updateLiveObjects()
		return objects
	}
	
	var releasedObjects = [WeakRef]()
	
	func updateLiveObjects() {
		if keepReleasedObjects {
			releasedObjects.appendContentsOf(objects.filter { $0.object == nil })
		}
		objects = objects.filter { $0.object != nil }
	}
	
	func add(object: AnyObject, file: String = #file, line: Int = #line, date: NSDate = NSDate()) {
		objects.append(WeakRef(object, file: file.componentsSeparatedByString("/").last ?? "", line: line, date: date))
	}
	
// could call this from the debugger while in a Swift frame 
// "call LiveObjectList.sharedInstance.printLiveObjects()"
	func printLiveObjects() {
		updateLiveObjects()
		objects.forEach {
			$0.printObject()
		}
	}
}

private let dateFormatter: NSDateFormatter = {
	let formatter = NSDateFormatter()
	formatter.dateStyle = .ShortStyle
	formatter.timeStyle = .ShortStyle
	return formatter
}()

class WeakRef: Hashable {

	weak var object: AnyObject?
	var objectType: AnyObject.Type
	var file: String
	var line: Int
	var date: NSDate
	
	var hashValue: Int { return object?.hashValue ?? 0 }
	
	init(_ object: AnyObject, file: String, line: Int, date: NSDate) {
		self.object = object
		self.file = file
		self.line = line
		self.date = date
		objectType = object.dynamicType
	}
	
	func printObject() {
		print(objectDescription)
	}
	
	var objectDescription: String {
		return "\(objectType) \(file):\(line) \(dateFormatter.stringFromDate(date))"
	}
}

func ==(lhs: WeakRef, rhs: WeakRef) -> Bool {
	return lhs.object === rhs.object
}

class LiveObjectTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
	
    override init(frame: CGRect, style: UITableViewStyle) {
		super.init(frame: frame, style: style)
		delegate = self
		dataSource = self
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		delegate = self
		dataSource = self
	}

	var liveObjects = LiveObjectList.sharedInstance.liveObjects {
		didSet {
			reloadData()
		}
	}
	
	func reloadLiveObjects() {
		liveObjects = LiveObjectList.sharedInstance.liveObjects
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return liveObjects.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let object = liveObjects[indexPath.row]
		let cell = tableView.dequeueReusableCellWithIdentifier("Cell") ?? UITableViewCell(style: .Default, reuseIdentifier: "Cell")
		cell.textLabel?.text = "\(object.objectType) \(object.file):\(object.line)"
		cell.detailTextLabel?.text = dateFormatter.stringFromDate(object.date)
		cell.textLabel?.numberOfLines = 0
		cell.textLabel?.lineBreakMode = .ByWordWrapping
		return cell
	}
	
	func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return rowHeight
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
}

extension UIViewController {

	@IBAction func showLiveObjects() {
		
		let vc = UIViewController()
		vc.view = LiveObjectTableView()
		vc.navigationItem.title = "Live Objects"
		vc.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(dimissLiveObjects))
		
		let nvc = UINavigationController(rootViewController: vc)
		presentViewController(nvc, animated: true, completion: nil)
	}
	
	func dimissLiveObjects() {
		dismissViewControllerAnimated(true, completion: nil)
	}
}