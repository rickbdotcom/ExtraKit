import Foundation

public protocol Configurable {
}

public extension Configurable where Self: AnyObject {
    @discardableResult public func configure(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

public extension NSObjectProtocol {
	@discardableResult func configure(_ block: (Self)->Void) -> Self {
		block(self)
		return self
	}
}

public func clamp<T: Comparable>(_ value: T, min mn: T, max mx: T) -> T
{
	return min(max(value,mn),mx)
}

public extension URL {
	static func temporaryFile(withExtension ext: String? = nil) -> URL {
		return URL(fileURLWithPath: NSTemporaryDirectory() + UUID().uuidString + (ext.flatMap{".\($0)"} ?? ""))
	}
}
