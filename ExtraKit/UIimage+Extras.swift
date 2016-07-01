import UIKit

public extension UIImage
{
    class func imageWithColor(color: UIColor) -> UIImage
	{
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        color.set()
        CGContextFillRect(context, rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
		image.setAssociatedValue(color, forKey: "UIImage.imageWithColor")
		return image
    }
	
	var imageColor: UIColor? {
		return associatedValueForKey("UIImage.imageWithColor")
	}
	
	class func draw(size: CGSize, draw: (context: CGContext, bounds: CGRect)->Void) -> UIImage?
	{
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
		
		draw(context: context, bounds: CGRectMake(0.0, 0.0, size.width, size.height))
		
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

		return image
	}
	
	class func filledCircle(radius r: CGFloat, color: UIColor) -> UIImage?
	{
		return draw(CGSizeMake(r,r)) { context, bounds in
			color.set()
			CGContextFillEllipseInRect(context, bounds)
		}
	}

	class func strokeCircle(radius r: CGFloat, width w: CGFloat, color: UIColor) -> UIImage?
	{
		return draw(CGSizeMake(r,r)) { context, bounds in
			color.set()
			CGContextSetLineWidth(context, w)
			CGContextStrokeEllipseInRect(context, bounds)
		}
	}
}