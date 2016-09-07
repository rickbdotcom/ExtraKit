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

	public init(nibName: String, resizeToNib: Bool = true) {
		super.init(frame: CGRectMake(0,0,320,320))
		self.resizeToNib = resizeToNib
		
		if !nibName.isEmpty {
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
		view.translatesAutoresizingMaskIntoConstraints = false
		addSubview(view)
		
		if resizeToNib {
			bounds = view.frame
		}
		view.topAnchor.constraintEqualToAnchor(topAnchor).active = true
		view.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
		view.leftAnchor.constraintEqualToAnchor(leftAnchor).active = true
		view.rightAnchor.constraintEqualToAnchor(rightAnchor).active = true
	}
}

public extension UIBarButtonItem {
	
	var control: UIControl? {
		return customView as? UIControl
	}
	
	convenience init(nibName: String) {
		self.init(customView: NibControl(nibName: nibName))
		width = customView?.bounds.size.width ?? 0
	}
}

public class NibBarButtonItem: UIBarButtonItem {
	@IBInspectable var nibName: String = ""

	public override func awakeFromNib() {
		super.awakeFromNib()
		if !nibName.isEmpty {
			customView = NibControl(nibName: nibName)
		}
	}
}