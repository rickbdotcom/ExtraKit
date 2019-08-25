//
//  CoreGraphics.swift
//  ExtraKit
//
//  Created by rickb on 4/18/16.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

import CoreGraphics

public extension CGSize {

	enum AspectMode {
		case fit
		case fill
	}

	func aspect(_ mode: AspectMode, in rect: CGRect) -> CGRect {
		let size = aspect(mode, in: rect.size)
		return rect.insetBy(dx: (rect.size.width - size.width) / 2.0, dy: (rect.size.height - size.height) / 2.0)
	}
	
	func aspect(_ mode: AspectMode, in size: CGSize) -> CGSize {
		return scale(aspectScale(mode, in: size))
	}
	
	func aspectScale(_ mode: AspectMode, in size: CGSize) -> CGFloat {
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
	
	func scale(_ scale: CGFloat) -> CGSize {
		return self.scale(x: scale, y: scale)
	}
}

public extension CGRect {

	init(center: CGPoint, size: CGSize) {
		self.init(origin: CGPoint(x: center.x - size.width / 2.0, y: center.y - size.height / 2.0), size: size)
	}

	init(size: CGSize) {
		self.init(origin: .zero, size: size)
	}
	
	init(x: CGFloat? = nil, y: CGFloat? = nil, width: CGFloat? = nil, height: CGFloat? = nil) {
		self.init(x: x ?? 0, y: y ?? 0, width: width ?? 0, height: height ?? 0)
	}
	
	var minXEdge: CGFloat {
		get { return minX }
		set { size.width += minX - newValue; origin.x = newValue }
	}

	var minYEdge: CGFloat {
		get { return minY }
		set { size.height += minY - newValue; origin.y = newValue }
	}

	var maxXEdge: CGFloat {
		get { return maxX }
		set { size.width += newValue - maxX }
	}

	var maxYEdge: CGFloat {
		get { return maxY }
		set { size.height += newValue - maxY }
	}
	
	var minXminY: CGPoint {
		get { return CGPoint(x: minX, y: minY) }
		set { minXEdge = newValue.x; minYEdge = newValue.y }
	}
	
	var minXmaxY: CGPoint {
		get { return CGPoint(x: minX, y: maxY) }
		set { minXEdge = newValue.x; maxYEdge = newValue.y }
	}
		
	var maxXminY: CGPoint {
		get { return CGPoint(x: maxX, y: minY) }
		set { maxXEdge = newValue.x; minYEdge = newValue.y }
	}

	var maxXmaxY: CGPoint {
		get { return CGPoint(x: maxX, y: maxY) }
		set { maxXEdge = newValue.x; maxYEdge = newValue.y }
	}

	var center: CGPoint {
		get { return CGPoint(x: midX, y: midY) }
		set { origin = CGPoint(x: newValue.x - size.width / 2, y: newValue.y - size.height / 2) }
	}
	
	func scale(x: CGFloat, y: CGFloat) -> CGRect {
		return CGRect(origin: origin.scale(x: x, y: y), size: size.scale(x: x, y: y))
	}
	
	func scale(_ scale: CGFloat) -> CGRect {
		return self.scale(x: scale, y: scale)
	}
}

public extension CGPoint {

	func scale(x: CGFloat, y: CGFloat) -> CGPoint {
		return CGPoint(x: self.x * x, y: self.y * y)
	}
	
	func scale(_ scale: CGFloat) -> CGPoint {
		return self.scale(x: scale, y: scale)
	}
}

public extension CGContext {

	func pushGState(block: () -> Void) {
		saveGState()
		block()
		restoreGState()
	}
	
	func rotate(at point: CGPoint, by offset: CGFloat, block: (() -> Void)? = nil) {
		pushGState {
			translateBy(x: point.x, y: point.y)
			rotate(by: offset)
			translateBy(x: -point.x, y: -point.y)
			block?()
		}
	}
}
