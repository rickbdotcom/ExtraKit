import Foundation
import CoreGraphics

public extension CGSize {

	enum aspectMode {
		case fit
		case fill
	}

	func aspect(_ mode: aspectMode, inRect rect: CGRect) -> CGRect {
		let size = aspect(mode, inSize: rect.size)
		return rect.insetBy(dx: (rect.size.width - size.width) / 2.0, dy: (rect.size.height - size.height) / 2.0)
	}
	
	func aspect(_ mode: aspectMode, inSize size: CGSize) -> CGSize {
		return scale(aspectScale(mode, inSize: size))
	}
	
	func aspectScale(_ mode: aspectMode, inSize size: CGSize) -> CGFloat {
		let test = size.width * height > size.height * width
		switch mode {
			case .fill:
				return test ? size.width / width : size.height / height
			case .fit:
				return test ? size.height / height : size.width / width
		}
	}

	func scale(x: CGFloat, y: CGFloat) -> CGSize {
		return CGSize(width: width * x, height: height * y)
	}
	
	func scale(_ s: CGFloat) -> CGSize {
		return scale(x: s, y: s)
	}
}

public extension CGRect {

	init(center: CGPoint, size: CGSize) {
		self.init(origin: CGPoint(x: center.x - size.width / 2.0, y: center.y - size.height / 2.0), size: size)
	}

	func scale(x: CGFloat, y: CGFloat) -> CGRect {
		return CGRect(origin: origin.scale(x: x, y: y), size: size.scale(x: x, y: y))
	}
	
	func scale(_ s: CGFloat) -> CGRect {
		return scale(x: s, y: s)
	}
}

public extension CGPoint {

	func scale(x: CGFloat, y: CGFloat) -> CGPoint {
		return CGPoint(x: self.x * x, y: self.y * y)
	}
	
	func scale(_ s: CGFloat) -> CGPoint {
		return scale(x: s, y: s)
	}

}

extension CGContext {

	func pushGState(block: ()->Void) {
		saveGState()
		block()
		restoreGState()
	}
	
	func rotate(at: CGPoint, by: CGFloat, block: (()->Void)? = nil) {
		pushGState {
			translateBy(x: at.x, y: at.y)
			rotate(by: by)
			translateBy(x: -at.x, y: -at.y)
			block?()
		}
	}
}

extension CGRect {
	var minXminY: CGPoint { return CGPoint(x: minX, y: minY) }
	var minXmaxY: CGPoint { return CGPoint(x: minX, y: maxY) }
	var maxXminY: CGPoint { return CGPoint(x: maxX, y: minY) }
	var maxXmaxY: CGPoint { return CGPoint(x: maxX, y: maxY) }
}

