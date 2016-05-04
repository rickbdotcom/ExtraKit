import ObjectiveC
import UIKit

public extension UIResponder
{
	@IBOutlet weak var nextTextInputResponder: UIResponder? {
		get {
			return weakAssociatedValueForKey("UIResponder.nextTextInputResponder")
		}
		set {
			setWeakAssociatedValue(newValue, forKey: "UIResponder.nextTextInputResponder")

			if newValue?.previousTextInputResponder != self {
				newValue?.previousTextInputResponder = self
			}
			createPreviousNextDoneInputAccessory()
			updatePreviousNextSegmentControlState()
		}
	}
	
	@IBOutlet weak var previousTextInputResponder: UIResponder? {
		get {
			return weakAssociatedValueForKey("UIResponder.previousTextInputResponder")
		}
		set {
			setWeakAssociatedValue(newValue, forKey: "UIResponder.previousTextInputResponder")

			if newValue?.nextTextInputResponder != self {
				newValue?.nextTextInputResponder = self
			}
			createPreviousNextDoneInputAccessory()
			updatePreviousNextSegmentControlState()
		}
	}

	var previousNextSegmentControl: UISegmentedControl? {
		return previousNextDoneInputAccessory?.items?.first?.customView as? UISegmentedControl
	}
	
	var previousNextDoneInputAccessory: UIToolbar? {
		guard self is UITextInputTraits  else { return nil }

		if let tf = self as? UITextField {
			return tf.inputAccessoryView as? UIToolbar
		} else if let tf = self as? UITextView {
			return tf.inputAccessoryView as? UIToolbar
		}else {
			return nil
		}
	}
	
	func createPreviousNextDoneInputAccessory()
	{
		guard let tf = self as? UITextInputTraits where previousNextDoneInputAccessory == nil else { return }

		let segmentControl = UISegmentedControl(items: ["Prev","Next"])
		segmentControl.sizeToFit()
		segmentControl.momentary = true
		segmentControl.addTarget(self, action: #selector(prevNextResponder(_:)), forControlEvents: .ValueChanged)
		
		let toolbar = UIToolbar()
		toolbar.barStyle = tf.keyboardAppearance  == .Dark ? .Black : .Default
		toolbar.sizeToFit()
		
		toolbar.items = [
			UIBarButtonItem(customView: segmentControl)
		,	UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
		,	UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(resignFirstResponder))
		]

		if let tf = self as? UITextField {
			tf.inputAccessoryView = toolbar
		} else if let tf = self as? UITextView {
			tf.inputAccessoryView = toolbar
		}
		updatePreviousNextSegmentControlState()
	}
	
	func becomePreviousFirstResponder(sender: UIResponder) -> Bool
	{
		return becomeFirstResponder()
	}
	
	func becomeNextFirstResponder(sender: UIResponder) -> Bool
	{
		return becomeFirstResponder()
	}
	
	func becomePreviousInputResponder() -> Bool
	{
		return self.previousTextInputResponder?.becomePreviousFirstResponder(self) ?? false
	}
	
	func becomeNextInputResponder() -> Bool
	{
		return self.nextTextInputResponder?.becomeNextFirstResponder(self) ?? false
	}

	func prevNextResponder(sender: UISegmentedControl)
	{
		if sender.selectedSegmentIndex == 0 {
			becomePreviousInputResponder()
		} else {
			becomeNextInputResponder()
		}
	}
	
	func updatePreviousNextSegmentControlState()
	{
		previousNextSegmentControl?.setEnabled(previousTextInputResponder != nil, forSegmentAtIndex: 0)
		previousNextSegmentControl?.setEnabled(nextTextInputResponder != nil, forSegmentAtIndex: 1)
	}
}