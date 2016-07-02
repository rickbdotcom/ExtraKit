import UIKit

public extension UIImage
{
	var imageColor: UIColor? {
		return associatedValueForKey("UIImage.imageWithColor")
	}

	class func draw(size: CGSize,  scale: CGFloat = UIScreen.mainScreen().scale, draw: (context: CGContext?, bounds: CGRect)->Void) -> UIImage
	{
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()
		
		draw(context: context, bounds: CGRectMake(0.0, 0.0, size.width, size.height))
		
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

		return image
	}

    class func imageWithColor(color: UIColor)-> UIImage
	{
		let image = draw(CGSizeMake(1,1), scale:1.0) { context, bounds in
			color.set()
			CGContextFillRect(context, bounds)
		}
		image.setAssociatedValue(color, forKey: "UIImage.imageWithColor")
		return image
    }
	
	class func filledCircle(radius r: CGFloat, color: UIColor, scale: CGFloat = UIScreen.mainScreen().scale) -> UIImage
	{
		return draw(CGSizeMake(r,r)) { context, bounds in
			color.set()
			CGContextFillEllipseInRect(context, bounds)
		}
	}

	class func strokeCircle(radius r: CGFloat, width w: CGFloat, color: UIColor, scale: CGFloat = UIScreen.mainScreen().scale) -> UIImage
	{
		return draw(CGSizeMake(r,r)) { context, bounds in
			color.set()
			CGContextSetLineWidth(context, w)
			CGContextStrokeEllipseInRect(context, bounds.insetBy(dx: w/2.0, dy: w/2.0))
		}
	}
}