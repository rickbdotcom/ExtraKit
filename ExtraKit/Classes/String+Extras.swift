import UIKit
import MobileCoreServices

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

    var isEmptyOrNilOrSpaces: Bool {
        return isEmptyOrNil
		|| (self as? String)?.trimmingCharacters(in: .whitespacesAndNewlines).characters.count == 0
    }
}


public extension String {
	
	var fileExtensionForMimeType: String? {
		if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, self as CFString, nil)?.takeRetainedValue()
		,  let ext = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassFilenameExtension)?.takeRetainedValue() {
			return ext as String
		}
		return  nil
	}
	
	var UTI: String? {
		return UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, self as CFString, nil)?.takeRetainedValue() as? String
	}
}
