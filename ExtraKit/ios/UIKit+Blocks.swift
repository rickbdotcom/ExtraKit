import UIKit

public extension NSObject {
	
	var targetBlocks: NSMutableSet { return getAssociatedValue(NSMutableSet()) }
	
	func remove(targetBlock: Any?) {
		if let targetBlock = targetBlock {
			targetBlocks.remove(targetBlock)
		}
	}
}

public extension UIControl {

	@discardableResult func on<T:UIControl>(_ event: UIControlEvents, block: @escaping (T)->Void) -> Any? {
		guard self is T else {
			return nil
		}
		return TargetBlock(block).configure {
			addTarget($0, action: #selector(TargetBlock.execute(_:)), for: event)
			self.targetBlocks.add($0)
		}
	}
}

public extension UIGestureRecognizer {

	convenience init(target: @escaping (UIGestureRecognizer)->Void) {
		self.init()
		add(target: target)
	}
	
	@discardableResult func add(target: @escaping (UIGestureRecognizer)->Void) -> Any {
		return TargetBlock(target).configure {
			addTarget($0, action: #selector(TargetBlock.execute(_:)))
			self.targetBlocks.add($0)
		}
	}
}

public extension UIBarButtonItem {

	convenience init(block: @escaping (UIBarButtonItem)->Void) {
		self.init()
		setBlock(block)
	}
	
	@discardableResult func setBlock(_ block: @escaping (UIBarButtonItem)->Void) -> Any {
		return TargetBlock(block).configure {
			target = $0
			action = #selector(TargetBlock.execute(_:))
			self.targetBlocks.removeAllObjects()
			self.targetBlocks.add($0)
		}
	}
}


public extension UITextView {

	var textViewDelegate: TextViewDelegate {
		get { return getAssociatedValue(TextViewDelegate(textView: self)) }
	}
}

public class TextViewDelegate: NSObject, UITextViewDelegate {
	
	public var editingDidBegin: ((UITextView)->Void)?
	public var editingChanged: ((UITextView)->Void)?
	public var editingDidEnd: ((UITextView)->Void)?
	public var shouldChangeText: ((UITextView, NSRange, String) -> Bool)?
	
	init(textView: UITextView) {
		super.init()
		textView.delegate = self
	}

	public func textViewDidBeginEditing(_ textView: UITextView) {
		editingDidBegin?(textView)
	}
	
	public func textViewDidEndEditing(_ textView: UITextView) {
		editingDidEnd?(textView)
	}
	
	public func textViewDidChange(_ textView: UITextView) {
		editingChanged?(textView)
	}
	
	public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		return shouldChangeText?(textView, range, text) ?? true
	}
}


class TargetBlock<T:NSObject>: NSObject {
	
	var block: (T)->Void
	
	init(_ block: @escaping (T)->Void) {
		self.block = block
	}
	
	@objc func execute(_ control: UIControl) {
		if let control = control as? T {
			block(control)
		}
	}
}
