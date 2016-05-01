import UIKit

public class PickerInputView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate
{
	var components = [[String]]()

	weak var textField: UITextField?

	var selectedValues: [String?]
	{
		return (0..<components.count).map {
			selectedValueInComponent($0)
		}
	}
	
	public func selectedValueInComponent(component: Int) -> String?
	{
		let selectedRow = selectedRowInComponent(component)
		if selectedRow < 0 { return nil }
		return components[component][selectedRow]
	}

	public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
	{
		return components[component][row]
	}
	
	public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
	{
		return components[component].count
	}
	
	public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
	{
		return components.count
	}
	
	public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
	{
		textField?.text = selectedValues.flatMap{$0}.joinWithSeparator(" ")
		NSNotificationCenter.defaultCenter().postNotificationName(UITextFieldTextDidChangeNotification, object: textField)
		textField?.sendActionsForControlEvents(.EditingChanged)
	}
}

public extension UITextField
{
	var pickerView: PickerInputView? {
		return inputView as? PickerInputView
	}
	
	func setPickerComponents(components: [[String]]) -> PickerInputView
	{
		let pickerView = PickerInputView()
		pickerView.components = components
		pickerView.textField = self
		pickerView.dataSource = pickerView
		pickerView.delegate = pickerView
		inputView = pickerView
		
		return pickerView
	}
}