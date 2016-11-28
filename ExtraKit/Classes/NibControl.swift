import UIKit

@IBDesignable open class NibControl: UIControl {

	@IBInspectable var nibName: String = ""

	@IBOutlet var contentView: UIView? {
		didSet {
			oldValue?.removeFromSuperview()
			addNibView(contentView)
		}
	}
	
	fileprivate var resizeToNib = false
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		translatesAutoresizingMaskIntoConstraints = false
	}

	public init(nibName: String, resizeToNib: Bool = true) {
		super.init(frame: CGRect(x: 0,y: 0,width: 320,height: 320))
		translatesAutoresizingMaskIntoConstraints = false
		self.resizeToNib = resizeToNib
		
		if !nibName.isEmpty {
			UINib(nibName: nibName, bundle: nil).instantiate(withOwner: self, options: nil)
		}
	}
	
	open override func awakeFromNib() {
		super.awakeFromNib()
		if !nibName.isEmpty {
			UINib(nibName: nibName, bundle: nil).instantiate(withOwner: self, options: nil)
		}
	}
	
	open override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		if !nibName.isEmpty {
			UINib(nibName: nibName, bundle: Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil)
		}
	}

	func addNibView(_ view: UIView?) {
		guard let view = view  else {
			return
		}
		view.translatesAutoresizingMaskIntoConstraints = false
		addSubview(view)
		
		if resizeToNib {
			bounds = view.frame
		} else {
			view.frame = bounds
		}
		view.topAnchor.constraint(equalTo: topAnchor).isActive = true
		view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		view.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
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

open class NibBarButtonItem: UIBarButtonItem {
	@IBInspectable var nibName: String = ""

	open override func awakeFromNib() {
		super.awakeFromNib()
		if !nibName.isEmpty {
			customView = NibControl(nibName: nibName)
		}
	}
}
