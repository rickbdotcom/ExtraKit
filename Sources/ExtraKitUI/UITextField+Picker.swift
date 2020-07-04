//
//  UITextField+Picker.swift
//  ExtraKit
//
//  Created by rickb on 9/22/19.
//  Copyright © 2019 rickbdotcom LLC. All rights reserved.
//

import Foundation
import UIKit

public extension UITextField {

    func setPickerValues<T: Equatable>(_ values: [T], titleKeyPath: KeyPath<T, String>, textKeyPath: KeyPath<T, String>? = nil) {
        setPickerValues(values, title: { $0[keyPath: titleKeyPath] }, text: { $0[keyPath: textKeyPath ?? titleKeyPath] })
    }

    func setPickerValues<T: Equatable>(_ values: [T], titleKeyPath: KeyPath<T, String?>, textKeyPath: KeyPath<T, String?>? = nil) {
        setPickerValues(values, title: { $0[keyPath: titleKeyPath] }, text: { $0[keyPath: textKeyPath ?? titleKeyPath] })
    }

    func setPickerValues<T: Equatable>(_ values: [T], title: @escaping ((T) -> String?), text: ((T) -> String?)? = nil) {
		guard values.isEmpty == false else {
			self.inputView = nil
			return
		}
        var currentValue: T? = pickerView(for: T.self)?.selectedValue
        if let oldValue = currentValue, values.contains(oldValue) == false {
            currentValue = nil
        }
        let pickerView = PickerInputView(textField: self, values: values, title: title, text: text)
        self.inputView = pickerView

        self.text = (text ?? title)(currentValue ?? pickerView.selectedValue)
    }

    func selectPickerValue<T: Equatable>(_ value: T) {
        if let picker = pickerView(for: T.self) {
            picker.selectedValue = value
        } else if let picker = pickerView(for: Optional<T>.self) {
            picker.selectedValue = value
        }
    }

    func selectPickerValue<T: Equatable>(where matches: (T) -> Bool) {
        if let picker = pickerView(for: T.self), let value = picker.values.first(where: matches) {
            selectPickerValue(value)
        }
    }

    func selectedPickerValue<T: Equatable>(as type: T.Type = T.self) -> T? {
        if let picker = pickerView(for: T.self) {
            return picker.selectedValue
        } else if let picker = pickerView(for: Optional<T>.self) {
            return picker.selectedValue
        } else {
            return nil
        }
    }

    func selectedPickerValue<T: Equatable>(type: T.Type) -> T? {
        selectedPickerValue()
    }

    func values<T: Equatable>(type: T.Type) -> [T] {
        pickerView(for: T.self)?.values ?? []
    }

    private func pickerView<T: Equatable>(for: T.Type) -> PickerInputView<T>? {
        inputView as? PickerInputView<T>
    }
}

class PickerInputView<T: Equatable>: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {

    private weak var textField: UITextField?
    let values: [T]
    private let title: (T) -> String?
    private let text: (T) -> String?

    var selectedValue: T {
        get { values[selectedRow(inComponent: 0)] }
        set {
            if let index = values.firstIndex(of: newValue) {
                selectRow(index, inComponent: 0, animated: true)
                textField?.text = text(values[index])
            }
        }
    }

    init(textField: UITextField, values: [T], title: @escaping ((T) -> String?), text: ((T) -> String?)? = nil) {
        self.textField = textField
        self.values = values
        self.title = title
        self.text = text ?? title
        super.init(frame: .zero)
        self.dataSource = self
        self.delegate = self
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        values.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        title(values[row])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField?.text = text(selectedValue)
        textField?.sendActions(for: .valueChanged)
    }
}
