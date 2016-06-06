import UIKit

class ImagePickerController: UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
	var pickedMedia: ((UIImage)->Void)?
	
	func pickImageSheet(completion: (Void)->Void) -> UIAlertController
	{
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
		
		if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
			alert.addAction(UIAlertAction(title: "Photo Library", style: .Default) { _ in
				self.sourceType = .PhotoLibrary
				self.delegate = self
				completion()
			})
		}
		
		if UIImagePickerController.isSourceTypeAvailable(.Camera) {
			alert.addAction(UIAlertAction(title: "Take Photo", style: .Default) { _ in
				self.sourceType = .Camera
				self.delegate = self
				completion()
			})
		}
		return alert
	}
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
	{
		dismissViewControllerAnimated(true) { _ in
			if let image = info[UIImagePickerControllerEditedImage] as? UIImage ??  info[UIImagePickerControllerOriginalImage] as? UIImage
			{
				self.pickedMedia?(image)
			}
		}
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController)
	{
		dismissViewControllerAnimated(true, completion: nil)
	}
}

public extension UIViewController
{
	func pickImage(completion: (image: UIImage)->Void)
	{
		let controller = ImagePickerController()
		controller.pickedMedia = completion
		presentViewController(controller.pickImageSheet {
			self.presentViewController(controller, animated: true, completion: nil)
		}, animated: true, completion: nil)
	}
}