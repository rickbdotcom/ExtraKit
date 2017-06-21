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
	
	func selectedValue(_ component: Int = 0) -> String? {
		let selectedRow = self.selectedRow(inComponent: component)
		if selectedRow < 0 { return nil }
		return components[component][selectedRow]
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
		textField?.text = selectedValues.flatMap{$0}.joined(separator: " ")
		NotificationCenter.default.post(name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
		textField?.sendActions(for: .editingChanged)
	}
}

public extension UITextField
{
	var pickerView: PickerInputView? {
		return inputView as? PickerInputView
	}
	
	@discardableResult func setPicker(components: [[String]]) -> PickerInputView {
		let pickerView = PickerInputView()
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
		text = pickerView?.components[component][row]
	}
	
	func pickerViewSelect(value: String, component: Int = 0, animated: Bool = false) {
		if let index = pickerView?.components[component].index(of: value) {
			pickerView?.selectRow(index, inComponent: component, animated: animated)
		}
		text = value
	}
}
