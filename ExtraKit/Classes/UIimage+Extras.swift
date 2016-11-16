import UIKit

private let imageColorAssociatedValueKey = "com.rickb.extrakit.UIImage.imageWithColor"

public extension UIImage {

	var imageColor: UIColor? {
		get {
			return associatedValue(forKey: imageColorAssociatedValueKey)
		}
		set {
			set(associatedValue: newValue, forKey: imageColorAssociatedValueKey)
		}
	}

	class func draw(size: CGSize,  scale: CGFloat = UIScreen.main.scale, draw: (_ context: CGContext, _ bounds: CGRect)->Void) -> UIImage? {

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
		guard let context = UIGraphicsGetCurrentContext() else {
			return nil
		}
		
		draw(context, CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
		
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

		return image
	}

    class func image(color: UIColor)-> UIImage? {

		let image = draw(size: CGSize(width: 1,height: 1), scale:1.0) { context, bounds in
			color.set()
			context.fill(bounds)
		}
		image?.imageColor = color
		return image
    }
	
	class func filledCircle(radius r: CGFloat, color: UIColor, scale: CGFloat = UIScreen.main.scale) -> UIImage? {

		return draw(size: CGSize(width: r,height: r)) { context, bounds in
			color.set()
			context.fillEllipse(in: bounds)
		}
	}

	class func strokeCircle(radius r: CGFloat, width w: CGFloat, color: UIColor, scale: CGFloat = UIScreen.main.scale) -> UIImage? {

		return draw(size: CGSize(width: r,height: r)) { context, bounds in
			color.set()
			context.setLineWidth(w)
			context.strokeEllipse(in: bounds.insetBy(dx: w/2.0, dy: w/2.0))
		}
	}
	
	class func filledRect(size s: CGSize, color: UIColor, scale: CGFloat = UIScreen.main.scale) -> UIImage? {

		return draw(size: s) { context, bounds in
			color.set()
			context.fill(bounds)
		}
	}
	
	class func strokeRect(size s: CGSize, width w: CGFloat, color: UIColor, scale: CGFloat = UIScreen.main.scale) -> UIImage? {

		return draw(size: s) { context, bounds in
			color.set()
			context.setLineWidth(w)
			context.stroke(bounds.insetBy(dx: w/2.0, dy: w/2.0))
		}	
	}
}
