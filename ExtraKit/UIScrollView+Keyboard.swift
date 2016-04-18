import UIKit

public extension UIScrollView
{
	func adjustContentInsetForKeyboardFrame()
	{
		associatedDictionary.setAssociatedValue(KeyboardNotificationObserver(scrollView:self), forKey: "UIScrollView.enableTextReveal")
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

		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
	}
	
	deinit
	{
		NSNotificationCenter.defaultCenter().removeObserver(self)
		keyboardWillHide()
	}
	
	func keyboardWillShow(note: NSNotification)
	{
		guard let scrollView = scrollView, keyboardFrame = note.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue() else { return }

		contentInset = scrollView.contentInset
		scrollView.contentInset.bottom = keyboardFrame.size.height
	}
	
	func keyboardWillHide()
	{
		scrollView?.contentInset = contentInset
	}
}