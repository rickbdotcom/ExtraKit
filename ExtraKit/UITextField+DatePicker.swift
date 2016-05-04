import UIKit

public class DatePickerInputView: UIDatePicker
{
	weak var textField: UITextField?
	var dateFormatter: NSDateFormatter!
	var dateString: String {
		return dateFormatter.stringFromDate(date)
	}
	
	func dateChanged() {
		textField?.text = dateString
		NSNotificationCenter.defaultCenter().postNotificationName(UITextFieldTextDidChangeNotification, object: textField)
		textField?.sendActionsForControlEvents(.EditingChanged)
	}
}

public extension UITextField
{
	var datePickerView: DatePickerInputView? {
		return inputView as? DatePickerInputView
	}
	
	func setDatePickerInputView(datePickerMode mode:UIDatePickerMode, dateFormatter: NSDateFormatter) -> DatePickerInputView
	{
		let picker = DatePickerInputView()
		picker.dateFormatter = dateFormatter
		picker.datePickerMode = mode
		picker.textField = self
		if let text = text where !text.isEmpty {
			picker.date = dateFormatter.dateFromString(text) ?? NSDate()
		}
		picker.addTarget(picker, action: #selector(DatePickerInputView.dateChanged), forControlEvents: .ValueChanged)
		inputView = picker
		return picker
	}
	
	var datePickerDate: NSDate? {
		get {
			return (text == datePickerView?.dateString) ? datePickerView?.date : nil
		}
		set {
			if let date = newValue {
				datePickerView?.date = date
				text = datePickerView?.dateString
			}
		}
	}
}