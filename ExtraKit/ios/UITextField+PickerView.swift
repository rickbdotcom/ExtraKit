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
			return selectedValues.flatMap{$0}.joined(separator: " ")
		}
	}
}

public extension UITextField
{
	var pickerView: PickerInputView? {
		return inputView as? PickerInputView
	}
	
	@discardableResult func setPicker(components: [[String]], custom: PickerInputView? = nil) -> PickerInputView {
		let pickerView = custom ?? PickerInputView()
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
