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
	func find<T>(predicate: (Element) -> Bool) -> T? {
		if let index = indexOf(predicate) {
			return self[index] as? T
		}
		return nil
	}
}

public extension NSObjectProtocol {
	func configure(block: (Self)->Void) -> Self {
		block(self)
		return self
	}
}

public class Lift<T>: NSObject {
	public var value: T!
	
	public init(_ value: T) {
		super.init()
		self.value = value
	}
}