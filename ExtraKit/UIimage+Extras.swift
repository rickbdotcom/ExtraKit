import UIKit

public extension UIImage
{
    class func imageWithColor(color: UIColor) -> UIImage
	{
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
		image.associatedDictionary["UIImage.imageWithColor"] = color
        return image
    }
	
	var imageColor: UIColor? {
		return associatedDictionary["UIImage.imageWithColor"] as? UIColor
	}
}