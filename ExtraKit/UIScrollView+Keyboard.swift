import UIKit

private let associatedValueKey = "com.rickb.extrakit.UIScrollView.enableTextReveal"

public extension UIScrollView
{
	func adjustContentInsetForKeyboardFrame()
	{
		setAssociatedValue(KeyboardNotificationObserver(scrollView: self), forKey: associatedValueKey)
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
			if let scrollView = self?.scrollView, keyboardFrame = note.keyboardFrameEnd {
				if self?.contentInset == nil {
					self?.contentInset = scrollView.contentInset
				}
				scrollView.contentInset.bottom = keyboardFrame.size.height
			}
		}
		
		startObserving(UIKeyboardWillHideNotification) { [weak self] note in
			if let contentInset = self?.contentInset {
				self?.scrollView?.contentInset = contentInset
				self?.contentInset = nil
			}
		}
	}
}

extension NSNotification
{
	var keyboardFrameEnd: CGRect?
	{
        if let info = self.userInfo, value = info[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            return value.CGRectValue()
        } else {
            return nil
        }
    }
}