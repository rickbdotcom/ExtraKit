import UIKit

class ImagePickerController: UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
	var pickedMedia: ((UIImage)->Void)?
	
	func pickImageSheet(_ completion: @escaping (Void)->Void) -> UIAlertController
	{
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		
		if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
			alert.addAction(UIAlertAction(title: "Photo Library", style: .default) { _ in
				self.sourceType = .photoLibrary
				self.delegate = self
				completion()
			})
		}
		
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			alert.addAction(UIAlertAction(title: "Take Photo", style: .default) { _ in
				self.sourceType = .camera
				self.delegate = self
				completion()
			})
		}
		return alert
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
	{
		dismiss(animated: true) { _ in
			if let image = info[UIImagePickerControllerEditedImage] as? UIImage ??  info[UIImagePickerControllerOriginalImage] as? UIImage
			{
				self.pickedMedia?(image)
			}
		}
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
	{
		dismiss(animated: true, completion: nil)
	}
}

public extension UIViewController
{
	func pickImage(_ completion: @escaping (_ image: UIImage)->Void)
	{
		let controller = ImagePickerController()
		controller.pickedMedia = completion
		present(controller.pickImageSheet {
			self.present(controller, animated: true, completion: nil)
		}, animated: true, completion: nil)
	}
}
