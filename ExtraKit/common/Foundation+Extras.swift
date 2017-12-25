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

public func clamp<T: Comparable>(_ value: T, min mn: T, max mx: T) -> T {
	return min(max(value,mn),mx)
}

public extension FileManager {
	func temporaryFile(withExtension ext: String? = nil) -> URL {
		return temporaryDirectory.appendingPathComponent(UUID().uuidString + (ext.flatMap{".\($0)"} ?? ""))
	}
}

public protocol EnumCollection: Hashable {
    static func cases() -> AnySequence<Self>
    static var all: [Self] { get }
}

public extension EnumCollection {
    
    public static func cases() -> AnySequence<Self> {
        return AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            return AnyIterator {
                let current: Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: self, capacity: 1) { $0.pointee } }
                guard current.hashValue == raw else {
                    return nil
                }
                raw += 1
                return current
            }
        }
    }
    
    public static var all: [Self] {
        return Array(self.cases())
    }
}
