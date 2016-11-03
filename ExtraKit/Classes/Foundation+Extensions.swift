import Foundation

public extension Dictionary {
    init<S: Sequence>
      (keyValues seq: S)
      where S.Iterator.Element == Element {
        self.init()
        self.merge(seq)
    }
 
    mutating func merge<S: Sequence>
      (_ seq: S)
      where S.Iterator.Element == Element {
        var gen = seq.makeIterator()
        while let (k,v) = gen.next() {
            self[k] = v
        }
    }
}

public extension Array {
	func find(_ predicate: (Element) -> Bool) -> Element? {
		if let index = index(where: predicate) {
			return self[index]
		}
		return nil
	}
}

public protocol Configurable {
}

public extension Configurable where Self: Any {
    @discardableResult public func configure( _ block: inout (Self) -> Void) -> Self {
        block(self)
        return self
    }
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

public func configure<V>(_ object:inout V, block: (V) -> Void) -> V {
	block(object)
    return object
}

public func clamp<T: Comparable>(_ value: T, min mn: T, max mx: T) -> T
{
	return min(max(value,mn),mx)
}
