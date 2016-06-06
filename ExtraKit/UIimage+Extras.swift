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
	
	class func circle(radius r: CGFloat, color: UIColor) -> UIImage
	{
        let rect = CGRectMake(0.0, 0.0, r, r)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        color.set()
        CGContextFillEllipseInRect(context, rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

		return image
	}
}