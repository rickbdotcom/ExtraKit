import UIKit

open class DatePickerInputView: UIDatePicker {

	weak var textField: UITextField?
	var dateFormatter: DateFormatter!
	var dateString: String {
		return dateFormatter.string(from: date)
	}
	
	@objc func dateChanged() {
		textField?.text = dateString
		NotificationCenter.default.post(name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
		textField?.sendActions(for: .editingChanged)
	}
	
	func setDate(text: String?) {
		if let text = text, let textDate = dateFormatter.date(from: text) {
			date = textDate
			textField?.text = text
		}
	}
}

public extension UITextField {

	var datePickerView: DatePickerInputView? {
		return inputView as? DatePickerInputView
	}
	
	@discardableResult func set(datePickerMode mode:UIDatePickerMode, dateFormatter: DateFormatter) -> DatePickerInputView {

		let picker = DatePickerInputView()
		picker.dateFormatter = dateFormatter
		picker.datePickerMode = mode
		picker.textField = self
		if let text = text , !text.isEmpty {
			picker.date = dateFormatter.date(from: text) ?? Date()
		}
		picker.addTarget(picker, action: #selector(DatePickerInputView.dateChanged), for: .valueChanged)
		inputView = picker
		return picker
	}
	
	var datePickerDate: Date? {
		get {
			return (text == datePickerView?.dateString) ? datePickerView?.date : nil
		}
		set {
			if let date = newValue {
				datePickerView?.date = date
				text = datePickerView?.dateString
			}else {
				text = nil
			}
		}
	}
}
