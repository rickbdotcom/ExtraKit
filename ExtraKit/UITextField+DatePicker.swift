import UIKit

public class DatePickerInputView: UIDatePicker
{
	weak var textField: UITextField?
	var dateFormatter: NSDateFormatter?
	
	func dateChanged() {
		textField?.text = dateFormatter?.stringFromDate(date)
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
}