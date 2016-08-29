import UIKit

public extension String {
	
	var localized: String {
		return NSLocalizedString(self, comment: "")
	}
	
	func localizedFormat(args: [CVarArgType]) -> String {
		return String(format: self.localized, locale: NSLocale.currentLocale(), arguments: args)
	}
}

public extension RawRepresentable where RawValue==String{
	var localized: RawValue {
		return rawValue.localized
	}

	func localized(args: CVarArgType...) -> RawValue {
		return rawValue.localizedFormat(args)
	}
}

public protocol OptionalString { }
extension String: OptionalString { }

public extension Optional where Wrapped: OptionalString {
    var isEmptyOrNil: Bool {
        return ((self as? String) ?? "").isEmpty
    }
}
