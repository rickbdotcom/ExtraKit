import UIKit

public extension String {
	
	var localized: String {
		return NSLocalizedString(self, comment: "")
	}
	
	func localizedFormat(_ args: [CVarArg]) -> String {
		return String(format: self.localized, locale: Locale.current, arguments: args)
	}
}

public extension RawRepresentable where RawValue==String{
	var localized: RawValue {
		return rawValue.localized
	}

	func localized(_ args: CVarArg...) -> RawValue {
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
