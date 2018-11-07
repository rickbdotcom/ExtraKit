//
//  Picker.swift
//  ExtraKit
//
//  Created by rickb on 4/18/16.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

import UIKit

public protocol AllValues {
	static var all: [Self] { get }
}

public protocol DisplayName {
	var displayName: String { get }
}

public protocol AllValuesPicker {

	func populateValues<T: AllValues & DisplayName>(_ type: T.Type, allowsUnselected: Bool)
	func selectedValue<T: AllValues>() -> T?
	func select<T: AllValues & Equatable>(value: T?)
}

public extension AllValues where Self: CaseIterable {
	static var all: [Self] { return Array(allCases) }
}

public extension RawRepresentable where Self: DisplayName, RawValue == String {

	var displayName: String {
        return "\(Self.self).\(rawValue)".localized()
	}
}

extension UISegmentedControl: AllValuesPicker {

	public func populateValues<T: AllValues & DisplayName>(_ type: T.Type, allowsUnselected: Bool = false) {
		removeAllSegments()
		type.all.reversed().forEach {
			insertSegment(withTitle: $0.displayName, at: 0, animated: false)
		}
	}
	
	public func selectedValue<T: AllValues>() -> T? {
		return (0..<T.all.count).contains(selectedSegmentIndex) ? T.all[selectedSegmentIndex] : nil
	}
	
	public func select<T: AllValues & Equatable>(value: T?) {
		selectedSegmentIndex = value.flatMap { T.all.index(of: $0) } ?? UISegmentedControl.noSegment
	}
}

