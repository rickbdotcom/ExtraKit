import UIKit

public extension NSMutableAttributedString {
    /// Replaces the base font (typically Times) with the given font, while preserving traits like bold and italic
    func setBaseFont(baseFont: UIFont, preserveFontSizes: Bool = false) {
        let baseDescriptor = baseFont.fontDescriptor()
        beginEditing()
        enumerateAttribute(NSFontAttributeName, inRange: NSMakeRange(0, length), options: []) { object, range, stop in
            if let font = object as? UIFont {
                // Instantiate a font with our base font's family, but with the current range's traits
                let traits = font.fontDescriptor().symbolicTraits
                let descriptor = baseDescriptor.fontDescriptorWithSymbolicTraits(traits)
                let newFont = UIFont(descriptor: descriptor, size: preserveFontSizes ? descriptor.pointSize : baseDescriptor.pointSize)
                self.removeAttribute(NSFontAttributeName, range: range)
                self.addAttribute(NSFontAttributeName, value: newFont, range: range)
            }
        }
        endEditing()
    }
}

public extension String {
	var localized: String {
		return NSLocalizedString(self, comment: "")
	}
}