import ObjectiveC

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
