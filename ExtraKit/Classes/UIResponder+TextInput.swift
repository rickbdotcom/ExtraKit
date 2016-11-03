import ObjectiveC
import UIKit

private let prevAssociatedValueKey = "com.rickb.extrakit.UIResponder.previousTextInputResponder"
private let nextAssociatedValueKey = "com.rickb.extrakit.UIResponder.nextTextInputResponder"

public extension UIResponder
{
	@IBOutlet weak var nextTextInputResponder: UIResponder? {
		get {
			return weakAssociatedValueForKey(nextAssociatedValueKey)
		}
		set {
			setWeakAssociatedValue(newValue, forKey: nextAssociatedValueKey)

			if newValue?.previousTextInputResponder != self {
				newValue?.previousTextInputResponder = self
			}
			createPreviousNextDoneInputAccessory()
			updatePreviousNextSegmentControlState()
		}
	}
	
	@IBOutlet weak var previousTextInputResponder: UIResponder? {
		get {
			return weakAssociatedValueForKey(prevAssociatedValueKey)
		}
		set {
			setWeakAssociatedValue(newValue, forKey: prevAssociatedValueKey)

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
		guard let tf = self as? UITextInputTraits , previousNextDoneInputAccessory == nil else { return }

		let segmentControl = UISegmentedControl(items: ["Prev".localized,"Next".localized])
		segmentControl.sizeToFit()
		segmentControl.isMomentary = true
		segmentControl.addTarget(self, action: #selector(prevNextResponder(_:)), for: .valueChanged)
		
		let toolbar = UIToolbar()
		toolbar.barStyle = tf.keyboardAppearance  == .dark ? .black : .default
		toolbar.sizeToFit()
		
		toolbar.items = [
			UIBarButtonItem(customView: segmentControl)
		,	UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		,	UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(resignFirstResponder))
		]

		if let tf = self as? UITextField {
			tf.inputAccessoryView = toolbar
		} else if let tf = self as? UITextView {
			tf.inputAccessoryView = toolbar
		}
		updatePreviousNextSegmentControlState()
	}
	
	func becomePreviousFirstResponder(_ sender: UIResponder) -> Bool
	{
		return becomeFirstResponder()
	}
	
	func becomeNextFirstResponder(_ sender: UIResponder) -> Bool
	{
		return becomeFirstResponder()
	}
	
	@discardableResult func becomePreviousInputResponder() -> Bool
	{
		return self.previousTextInputResponder?.becomePreviousFirstResponder(self) ?? false
	}
	
	@discardableResult func becomeNextInputResponder() -> Bool
	{
		return self.nextTextInputResponder?.becomeNextFirstResponder(self) ?? false
	}

	func prevNextResponder(_ sender: UISegmentedControl)
	{
		if sender.selectedSegmentIndex == 0 {
			becomePreviousInputResponder()
		} else {
			becomeNextInputResponder()
		}
	}
	
	func updatePreviousNextSegmentControlState()
	{
		previousNextSegmentControl?.setEnabled(previousTextInputResponder != nil, forSegmentAt: 0)
		previousNextSegmentControl?.setEnabled(nextTextInputResponder != nil, forSegmentAt: 1)
	}
}
