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

@discardableResult public func time_block(_ printTime: Bool = true, file: String = #file, function: String = #function, line: Int = #line, _ block: @noescape () -> Void) -> TimeInterval {
#if DEBUG
    var info = mach_timebase_info()
    guard mach_timebase_info(&info) == KERN_SUCCESS else { return -1 }

    let start = mach_absolute_time()
    block()
    let end = mach_absolute_time()

    let elapsed = end - start

    let nanos = elapsed * UInt64(info.numer) / UInt64(info.denom)
    let ti = TimeInterval(nanos) / TimeInterval(NSEC_PER_SEC)
	
	if printTime {
		print("elasped time:\(file):\(function):\(line):\(ti)")
	}
	return ti
#else
	block()
	return -1
#endif
}
