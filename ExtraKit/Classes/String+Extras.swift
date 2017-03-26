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
        return isEmptyOrNil || ((self as? String)?.isOnlySpaces ?? false)
    }
}


public extension String {

	func tag(withClass: CFString) -> String? {
		return UTTypeCopyPreferredTagWithClass(withClass, self as CFString)?.takeRetainedValue() as? String
	}
	
	func uti(withClass: CFString) -> String? {
		return UTTypeCreatePreferredIdentifierForTag(withClass, self as CFString, nil)?.takeRetainedValue() as? String
	}
	
	var utiMimeType: String? {
		return tag(withClass: kUTTagClassMIMEType)
	}
	
	var utiFileExtension: String? {
		return tag(withClass: kUTTagClassFilenameExtension)
	}
	
	var mimeTypeUTI: String? {
		return uti(withClass: kUTTagClassMIMEType)
	}

	var fileExtensionUTI: String? {
		return uti(withClass: kUTTagClassFilenameExtension)
	}

	func utiConforms(to: String) -> Bool {
		return UTTypeConformsTo(self as CFString, to as CFString)
	}
}

public extension String {

	var isOnlySpaces: Bool {
		return trimmingCharacters(in: .whitespacesAndNewlines).characters.count == 0
	}

	var emptyNil: String? {
		return isEmpty ? nil : self
	}

	var emptyNilSpace: String? {
		return isEmpty || isOnlySpaces ? nil : self
	}
}

public extension Sequence where Iterator.Element == String {
    public func joinedEmptyNilSpace(separator: String = "") -> String {
		return flatMap { $0.emptyNilSpace }.joined(separator: separator)
	}
}
