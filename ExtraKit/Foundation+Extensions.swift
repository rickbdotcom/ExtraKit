import Foundation

public extension Dictionary {
    init<S: SequenceType
      where S.Generator.Element == Element>
      (keyValues seq: S) {
        self.init()
        self.merge(seq)
    }
 
    mutating func merge<S: SequenceType
      where S.Generator.Element == Element>
      (seq: S) {
        var gen = seq.generate()
        while let (k,v) = gen.next() {
            self[k] = v
        }
    }
}

public extension Array {
	func find(predicate: (Element) -> Bool) -> Element? {
		if let index = indexOf(predicate) {
			return self[index]
		}
		return nil
	}

	func truncate(count: Int) -> Array
	{
		return Array(self[0..<min(self.count,count)])
	}
}

public extension NSObjectProtocol {
	func configure(@noescape block: (Self)->Void) -> Self {
		block(self)
		return self
	}
}

public class WrapAny<T>: NSObject {
	public var value: T!
	
	public init(_ value: T) {
		super.init()
		self.value = value
	}
}

public func clamp<T: Comparable>(value: T, min mn: T, max mx: T) -> T
{
	return min(max(value,mn),mx)
}