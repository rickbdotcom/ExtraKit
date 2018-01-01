public protocol NoArgInitable {
	init()
}

public func clamp<T: Comparable>(_ value: T, min mn: T, max mx: T) -> T {
	return min(max(value,mn),mx)
}
