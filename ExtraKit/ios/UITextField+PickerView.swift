//
//  UITextField+PickerView.swift
//  ExtraKit
//
//  Created by rickb on 4/18/16.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

import UIKit

open class PickerInputView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate
{
	var components = [[String]]()

	weak var textField: UITextField?

	var selectedValues: [String?] {
		return (0..<components.count).map {
			selectedValue($0)
		}
	}

	var selectedIndexes: [Int] {
		return (0..<components.count).map {
			selectedRow(inComponent: $0)
		}		
	}
	
	func selectedValue(_ component: Int = 0) -> String? {
		let row = selectedRow(inComponent: component)
		if row < 0 { return nil }
		return components[component][row]
	}

	open func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return components[component][row]
	}
    	
	open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return components[component].count
	}
	
	open func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return components.count
	}
	
	open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		textField?.text = text()
		NotificationCenter.default.post(name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
		textField?.sendActions(for: .editingChanged)
	}
	
	open var getText: ((PickerInputView) -> String)?
	
	func text() -> String {
		if let getText = getText {
			return getText(self)
		} else {
			return selectedValues.compactMap{$0}.joined(separator: " ")
		}
	}
}

public extension UITextField
{
	var pickerView: PickerInputView? {
		return inputView as? PickerInputView
	}
	
	@discardableResult func setPicker(_ picker: PickerInputView? = nil, components: [[String]] = [[]]) -> PickerInputView {
		let pickerView = picker ?? PickerInputView()
		pickerView.components = components
		pickerView.textField = self
		pickerView.dataSource = pickerView
		pickerView.delegate = pickerView
		inputView = pickerView
		
		return pickerView
	}
	
	func pickerViewSelectedValue(component: Int = 0) -> String? {
		return pickerView?.selectedValue(component)
	}
	
	func pickerViewSelect(row: Int, component: Int = 0, animated: Bool = false) {
		pickerView?.selectRow(row, inComponent: component, animated: true)
		text = pickerView?.text()
	}
	
	func pickerViewSelect(value: String, component: Int = 0, animated: Bool = false) {
		if let index = pickerView?.components[component].index(of: value) {
			pickerView?.selectRow(index, inComponent: component, animated: animated)
		}
		text = pickerView?.text()
	}
}

public extension UITextField {

	@discardableResult func setPicker<T: AllValues & DisplayName>(_ picker: PickerInputView? = nil, with type: T.Type, allowsUnselected: Bool = false) -> PickerInputView {
		let pickerView = setPicker(picker)
		pickerView.populateValues(type.self, allowsUnselected: allowsUnselected)
		return pickerView
	}
	
	func pickerViewSelect<T: AllValues & Equatable>(value: T?) {
		pickerView?.select(value: value)
		text = pickerView?.text()
	}
}

extension PickerInputView: AllValuesPicker {

	public var allowsUnselected: Bool {
		get { return associatedValue() ?? false }
		set { set(associatedValue: newValue) }
	}
	
	public func populateValues<T: AllValues & DisplayName>(_ type: T.Type, allowsUnselected: Bool = false) {
		components = [(allowsUnselected ? [""] : []) + T.all.map { $0.displayName }] 
	}
	
	public func selectedValue<T: AllValues>() -> T? {
		let index = selectedRow(inComponent: 0) - (allowsUnselected ? 1 : 0)
		return (0..<T.all.count).contains(index) ? T.all[index] : nil
	}
	
	public func select<T: AllValues & Equatable>(value: T?) {
		if let index = value.flatMap({ T.all.index(of: $0) }) {
			selectRow(index + (allowsUnselected ? 1 : 0), inComponent: 0, animated: false)			
		} else if allowsUnselected {
			selectRow(0, inComponent: 0, animated: false)
		}
	}
}
