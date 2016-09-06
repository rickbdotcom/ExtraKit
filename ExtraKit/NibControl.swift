import UIKit

@IBDesignable public class NibControl: UIControl {

	@IBInspectable var nibName: String = ""

	@IBOutlet var contentView: UIView? {
		didSet {
			oldValue?.removeFromSuperview()
			addNibView(contentView)
		}
	}
	
	private var resizeToNib = false
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	public init(nibName: String) {
		super.init(frame: CGRectMake(0,0,320,320))

		if !nibName.isEmpty {
			resizeToNib = true
			UINib(nibName: nibName, bundle: nil).instantiateWithOwner(self, options: nil)
		}
	}
	
	public override func awakeFromNib() {
		super.awakeFromNib()
		if !nibName.isEmpty {
			UINib(nibName: nibName, bundle: nil).instantiateWithOwner(self, options: nil)
		}
	}
	
	public override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		if !nibName.isEmpty {
			UINib(nibName: nibName, bundle: NSBundle(forClass: self.dynamicType)).instantiateWithOwner(self, options: nil)
		}
	}

	func addNibView(view: UIView?) {
		guard let view = view  else {
			return
		}
		addSubview(view)
		if resizeToNib {
			bounds = view.frame
		} else {
			view.frame = bounds
		}
		view.topAnchor.constraintEqualToAnchor(topAnchor).active = true
		view.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
		view.leftAnchor.constraintEqualToAnchor(leftAnchor).active = true
		view.rightAnchor.constraintEqualToAnchor(rightAnchor).active = true
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
