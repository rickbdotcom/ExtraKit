import UIKit

private let observerAssociatedValueKey = "com.rickb.extrakit.UIScrollView.KeyboardNotificationObserver"
private let revealViewAssociatedValueKey = "com.rickb.extrakit.UIScrollView.viewForKeyboardReveal"

public extension UIScrollView {
	func adjustContentInsetForKeyboardFrame()
	{
		set(associatedValue: KeyboardNotificationObserver(scrollView: self), forKey: observerAssociatedValueKey)
	}
}

class KeyboardNotificationObserver: NSObject {
	weak var scrollView: UIScrollView?
	var contentInset: UIEdgeInsets?
	var scrollIndicatorInsets: UIEdgeInsets?
	
	init(scrollView: UIScrollView) {
		super.init()

		self.scrollView = scrollView

		startObserving(NSNotification.Name.UIKeyboardWillChangeFrame) { [weak self] note in
			guard let scrollView = self?.scrollView else {
				return
			}
			if self?.contentInset == nil {
				self?.contentInset = scrollView.contentInset
			}
			if self?.scrollIndicatorInsets == nil {
				self?.scrollIndicatorInsets = scrollView.scrollIndicatorInsets
			}
			scrollView.contentInset.bottom = self?.adjustedKeyboardFrameHeight(note) ?? 0
			scrollView.scrollIndicatorInsets.bottom = scrollView.contentInset.bottom
// not sure about this	
			// self?.scrollToVisibleResponder(note)
		}
		
		startObserving(NSNotification.Name.UIKeyboardWillHide) { [weak self] note in
			guard let scrollView = self?.scrollView else {
				return
			}
			if let contentInset = self?.contentInset {
				scrollView.contentInset = contentInset
				self?.contentInset = nil
			}
			if let scrollIndicatorInsets = self?.scrollIndicatorInsets {
				scrollView.scrollIndicatorInsets = scrollIndicatorInsets
				self?.scrollIndicatorInsets = nil
			}
		}
	}
	
/*	func scrollToVisibleResponder(_ note: Notification) {
		if let scrollView = scrollView
		, let window = scrollView.window
		, let keyboardFrame = note.keyboardFrameEnd
		, let revealView = scrollView.findFirstResponder()?.viewForKeyboardReveal ?? scrollView.findFirstResponder()
		, scrollView.convert(window.convert(keyboardFrame, from: nil), from: nil).intersects(revealView.frame) {
			scrollView.scrollRectToVisible(revealView.frame, animated: true)
		}
	}*/
	
	func adjustedKeyboardFrameHeight(_ note: Notification) -> CGFloat {
		guard let scrollView = scrollView, let keyboardFrame = note.keyboardFrameEnd else {
			return 0
		}
		
		var h = keyboardFrame.size.height
		let dh = UIScreen.main.bounds.size.height-scrollView.convert(scrollView.bounds, to: UIScreen.main.coordinateSpace).maxY
		if dh > 0 {
			h -= dh
		}
		if h < 0 {
			h = 0
		}
		return h
	}
}

public extension UIResponder {

	@IBOutlet public weak var viewForKeyboardReveal: UIView? {
		get {
			return weakAssociatedValue(forKey: observerAssociatedValueKey)
		}
		set {
			set(weakAssociatedValue: newValue, forKey: observerAssociatedValueKey)
		}
	}
}

public extension Notification {

	var keyboardFrameEnd: CGRect?
	{
        if let info = (self as NSNotification).userInfo, let value = info[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            return value.cgRectValue
        } else {
            return nil
        }
    }
}
