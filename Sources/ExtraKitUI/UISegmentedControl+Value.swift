//
//  UISegmentedControl+Value.swift
//  newman
//
//  Created by rickb on 2/20/20.
//  Copyright © 2020 Newman. All rights reserved.
//

import Foundation
import UIKit

extension UISegmentedControl {

	func setSelectedValue<T: Equatable>(_ value: T?) {
		guard let values: [T] = self.values() else {
			return
		}
		if let value = value {
			selectedSegmentIndex = values.firstIndex(of: value) ?? UISegmentedControl.noSegment
		} else {
			selectedSegmentIndex = UISegmentedControl.noSegment
		}
	}

	func selectedValue<T: Equatable>() -> T? {
		guard let values: [T] = self.values(),
		(0 ..< values.count).contains(selectedSegmentIndex) else {
			return nil
		}
		return values[selectedSegmentIndex]
	}

	func setValues<T: Equatable>(_ values: [T]) {
		valuesStorage = values
	}

	private func values<T>() -> [T]? {
		valuesStorage as? [T]
	}

	private var valuesStorage: Any? {
		get { associatedValue() }
		set { set(associatedValue: newValue) }
	}
}
