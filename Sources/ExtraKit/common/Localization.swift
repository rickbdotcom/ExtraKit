//
//  Localization.swift
//  ExtraKit
//
//  Created by rickb on 4/18/16.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

import Foundation

public protocol Localizable {
	func localized(tableName: String?, bundle: Bundle?, value: String?) -> String
	func localizedFormat(tableName: String?, _ args: CVarArg...) -> String
}

public extension String {
	
	func localized(tableName: String? = nil, bundle: Bundle? = nil, value: String? = nil) -> String {
		return NSLocalizedString(self, tableName:  tableName, bundle: bundle ?? Bundle.main, value: value ?? self, comment: "")
	}
	
	func localizedFormat(tableName: String? = nil, _ args: CVarArg...) -> String {
		return String(format: self.localized(tableName: tableName), locale: Locale.current, arguments: args)
	}
}

public extension RawRepresentable where RawValue==String{

	func localized(tableName: String? = nil, bundle: Bundle? = nil, value: String? = nil) -> RawValue {
		return rawValue.localized(tableName: tableName, bundle: bundle, value: value)
	}

	func localizedFormat(tableName: String? = nil, _ args: CVarArg...) -> RawValue {
		return String(format: self.localized(tableName: tableName), locale: Locale.current, arguments: args)
	}
}

public protocol StringTable {
	var tableName: String? { get }
}

public extension StringTable where Self: RawRepresentable, Self.RawValue == String {
	
	func localized(bundle: Bundle? = nil, value: String? = nil) -> RawValue {
		return localized(tableName: tableName, bundle: bundle, value: value)
	}
}

public protocol StringTableBundle: StringTable {
	var bundle: Bundle? { get }
}

public extension StringTableBundle where Self: RawRepresentable, Self.RawValue == String {
	
	func localized(value: String? = nil) -> RawValue {
		return localized(tableName: tableName, bundle: bundle, value: value)
	}
}
