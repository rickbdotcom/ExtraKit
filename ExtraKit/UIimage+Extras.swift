import UIKit

private let imageColorAssociatedValueKey = "com.rickb.extrakit.UIImage.imageWithColor"

public extension UIImage
{
	var imageColor: UIColor? {
		get {
			return associatedValueForKey(imageColorAssociatedValueKey)
		}
		set {
			setAssociatedValue(newValue, forKey: imageColorAssociatedValueKey)
		}
	}

	class func draw(size: CGSize,  scale: CGFloat = UIScreen.mainScreen().scale, draw: (context: CGContext, bounds: CGRect)->Void) -> UIImage?
	{
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
		guard let context = UIGraphicsGetCurrentContext() else {
			return nil
		}
		
		draw(context: context, bounds: CGRectMake(0.0, 0.0, size.width, size.height))
		
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

		return image
	}

    class func imageWithColor(color: UIColor)-> UIImage?
	{
		let image = draw(CGSizeMake(1,1), scale:1.0) { context, bounds in
			color.set()
			CGContextFillRect(context, bounds)
		}
		image?.imageColor = color
		return image
    }
	
	class func filledCircle(radius r: CGFloat, color: UIColor, scale: CGFloat = UIScreen.mainScreen().scale) -> UIImage?
	{
		return draw(CGSizeMake(r,r)) { context, bounds in
			color.set()
			CGContextFillEllipseInRect(context, bounds)
		}
	}

	class func strokeCircle(radius r: CGFloat, width w: CGFloat, color: UIColor, scale: CGFloat = UIScreen.mainScreen().scale) -> UIImage?
	{
		return draw(CGSizeMake(r,r)) { context, bounds in
			color.set()
			CGContextSetLineWidth(context, w)
			CGContextStrokeEllipseInRect(context, bounds.insetBy(dx: w/2.0, dy: w/2.0))
		}
	}
	
	class func filledRect(size s: CGSize, color: UIColor, scale: CGFloat = UIScreen.mainScreen().scale) -> UIImage?
	{
		return draw(s) { context, bounds in
			color.set()
			CGContextFillRect(context, bounds)
		}
	}
	
	class func strokeRect(size s: CGSize, width w: CGFloat, color: UIColor, scale: CGFloat = UIScreen.mainScreen().scale) -> UIImage?
	{
		return draw(s) { context, bounds in
			color.set()
			CGContextSetLineWidth(context, w)
			CGContextStrokeRect(context, bounds.insetBy(dx: w/2.0, dy: w/2.0))
		}	
	}
}
