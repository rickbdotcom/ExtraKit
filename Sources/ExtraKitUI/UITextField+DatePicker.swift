//
//  UITextField+DatePicker.swift
//  ExtraKit
//
//  Created by rickb on 4/18/16.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

import UIKit

class DatePickerInputView: UIDatePicker {

	weak var textField: UITextField?
	var dateFormatter = DateFormatter()
	var dateString: String {
		dateFormatter.string(from: date)
	}
	
	@objc func dateChanged() {
		textField?.text = dateString
		NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: textField)
		textField?.sendActions(for: .editingChanged)
	}
	
	func setDate(text: String?) {
		if let text = text, let textDate = dateFormatter.date(from: text) {
			date = textDate
			textField?.text = text
		}
	}
}

extension UITextField {

	var datePickerView: DatePickerInputView? {
		inputView as? DatePickerInputView
	}
	
	@discardableResult func set(datePickerMode mode: UIDatePicker.Mode, dateFormatter: DateFormatter) -> DatePickerInputView {

		let picker = DatePickerInputView()
		picker.dateFormatter = dateFormatter
		picker.datePickerMode = mode
		picker.textField = self
		if let text = text, text.isEmpty == false {
			picker.date = dateFormatter.date(from: text) ?? Date()
		}
		picker.addTarget(picker, action: #selector(DatePickerInputView.dateChanged), for: .valueChanged)
		inputView = picker
		return picker
	}
	
	var datePickerDate: Date? {
		get {
			(text == datePickerView?.dateString) ? datePickerView?.date : nil
		}
		set {
			if let date = newValue {
				datePickerView?.date = date
				text = datePickerView?.dateString
			} else {
				text = nil
			}
		}
	}
}
