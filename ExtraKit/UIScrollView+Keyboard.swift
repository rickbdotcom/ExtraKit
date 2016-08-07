import UIKit

private let observerAssociatedValueKey = "com.rickb.extrakit.UIScrollView.KeyboardNotificationObserver"
private let revealViewAssociatedValueKey = "com.rickb.extrakit.UIScrollView.viewForKeyboardReveal"

public extension UIScrollView
{
	func adjustContentInsetForKeyboardFrame()
	{
		setAssociatedValue(KeyboardNotificationObserver(scrollView: self), forKey: observerAssociatedValueKey)
	}
}

class KeyboardNotificationObserver: NSObject
{
	weak var scrollView: UIScrollView?
	var contentInset: UIEdgeInsets?
	
	init(scrollView: UIScrollView)
	{
		super.init()

		self.scrollView = scrollView

		startObserving(UIKeyboardWillChangeFrameNotification) { [weak self] note in
			if self?.contentInset == nil {
				self?.contentInset = scrollView.contentInset
			}
			scrollView.contentInset.bottom = self?.adjustedKeyboardFrameHeight(note) ?? 0
		}
		
		startObserving(UIKeyboardWillHideNotification) { [weak self] note in
			if let contentInset = self?.contentInset {
				self?.scrollView?.contentInset = contentInset
				self?.contentInset = nil
			}
		}
	}
	
	func adjustedKeyboardFrameHeight(note: NSNotification) -> CGFloat {
		guard let scrollView = scrollView, keyboardFrame = note.keyboardFrameEnd else {
			return 0
		}
		
		var h = keyboardFrame.size.height
		if let responder = scrollView.findFirstResponder(), revealView = responder.viewForKeyboardReveal {
			let responderY = scrollView.convertRect(responder.bounds, fromView: responder).maxY
			let revealY = scrollView.convertRect(revealView.bounds, fromView: revealView).maxY
			let dh = revealY - responderY
			if dh > 0 {
				h += dh
			}
		}
		return h // currently only for scrollviews that go all the way to the bottom the screen. TODO take into account scrollview bottom
	}
}

public extension UIResponder {

	@IBOutlet public weak var viewForKeyboardReveal: UIView? {
		get {
			return weakAssociatedValueForKey(observerAssociatedValueKey)
		}
		set {
			setWeakAssociatedValue(newValue, forKey: observerAssociatedValueKey)
		}
	}
}