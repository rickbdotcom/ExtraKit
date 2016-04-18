import Foundation

public extension Dictionary {
    init<S: SequenceType
      where S.Generator.Element == Element>
      (tuples seq: S) {
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
	func configure<T>(block: (T)->Void) -> T {
		block(self as! T)
		return self as! T
	}
}