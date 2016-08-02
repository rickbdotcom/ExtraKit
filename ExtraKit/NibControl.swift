import UIKit

@IBDesignable public class NibControl: UIControl {

	@IBInspectable var nibName: String = ""

	var view: UIView? {
		didSet {
			oldValue?.removeFromSuperview()
			addNibView(view)
		}
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	public init(nibName: String) {
		let view = UINib(nibName: nibName, bundle: nil).instantiateView()

		super.init(frame: view?.bounds ?? CGRectZero)
		self.nibName = nibName
		self.view = view
		addNibView(view)
	}
	
	public override func awakeFromNib() {
		super.awakeFromNib()
		view = UINib(nibName: nibName, bundle: nil).instantiateView()
	}
	
	public override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		view = UINib(nibName: nibName, bundle: NSBundle(forClass: self.dynamicType)).instantiateView()
	}

	func addNibView(view: UIView?) {
		guard let view = view  else { return }
		addSubview(view)
		view.topAnchor.constraintEqualToAnchor(topAnchor).active = true
		view.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
		view.leftAnchor.constraintEqualToAnchor(leftAnchor).active = true
		view.rightAnchor.constraintEqualToAnchor(rightAnchor).active = true
	}
}

extension UINib {
	func instantiateView() -> UIView? {
		return instantiateWithOwner(nil, options: nil).first as? UIView
	}
}

public extension UIBarButtonItem {

	public var control: UIControl? {
		return customView as? UIControl
	}

	public class func nibControl(nibName: String) -> UIBarButtonItem {
		return UIBarButtonItem(customView: NibControl(nibName: nibName)).configure {
			$0.width = $0.control?.bounds.size.width ?? 0
		}
	}
}
