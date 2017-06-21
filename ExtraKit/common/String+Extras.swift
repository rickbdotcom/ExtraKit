
#if os(OSX)
import CoreServices
#elseif os(iOS)
import MobileCoreServices
#endif

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

public extension Optional where Wrapped == String {

    var isEmptyOrNil: Bool {
        return (self ?? "").isEmpty
    }

    var isEmptyOrNilOrSpaces: Bool {
        return isEmptyOrNil || (self?.isOnlySpaces ?? false)
    }
}

public extension String {

	func tag(withClass: CFString) -> String? {
		return UTTypeCopyPreferredTagWithClass(self as CFString, withClass)?.takeRetainedValue() as String?
	}
	
	func uti(withClass: CFString) -> String? {
		return UTTypeCreatePreferredIdentifierForTag(withClass, self as CFString, nil)?.takeRetainedValue() as String?
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
