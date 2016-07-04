import UIKit

public extension UIScrollView
{
	func adjustContentInsetForKeyboardFrame()
	{
		setAssociatedValue(KeyboardNotificationObserver(scrollView: self), forKey: "UIScrollView.enableTextReveal")
	}
}

class KeyboardNotificationObserver: NSObject
{
	weak var scrollView: UIScrollView?
	var contentInset = UIEdgeInsetsZero
	
	init(scrollView: UIScrollView)
	{
		super.init()

		self.scrollView = scrollView

		startObserving(UIKeyboardWillShowNotification) { [weak self] note in
			if let scrollView = self?.scrollView, keyboardFrame = note.keyboardFrameEnd {
				self?.contentInset = scrollView.contentInset
				scrollView.contentInset.bottom = keyboardFrame.size.height
			}
		}
		
		startObserving(UIKeyboardWillHideNotification) { [weak self] note in
			if let contentInset = self?.contentInset {
				self?.scrollView?.contentInset = contentInset
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