//
//  SwiftUIPreview.swift
//  vitaminshoppe
//
//  Created by rickb on 10/18/19.
//  Copyright © 2019 vitaminshoppe. All rights reserved.
//

#if canImport(SwiftUI) && DEBUG && swift(>=5.1)
import Foundation
import SwiftUI
import UIKit

@available(iOS 13.0, *)
func previewOnDevices<Content: View>(_ devices: [String]? = nil, @ViewBuilder content: @escaping () -> Content) -> some View {
	if let devices = devices {
		return ForEach(devices, id: \.self) { deviceName in
			content()
				.previewDevice(PreviewDevice(rawValue: deviceName))
				.previewDisplayName(deviceName)
		}
	} else {
		return ForEach(devices ?? ["Preview"], id: \.self) { deviceName in
			return content().previewDevice(nil).previewDisplayName(deviceName)
		}
	}
}

@available(iOS 13.0, *)
extension UIViewController {

    func devicePreview(on devices: [String]? = nil) -> some View {
        return previewOnDevices(devices) {
            self.preview()
        }
    }
}

@available(iOS 13.0, *)
extension UIView {

    func devicePreview(on devices: [String]? = nil) -> some View {
        return previewOnDevices(devices) {
            self.preview()
        }
    }
}

@available(iOS 13.0, *)
struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    let viewController: ViewController

    init(_ builder: @escaping () -> ViewController) {
        viewController = builder()
    }

    func makeUIViewController(context: Context) -> ViewController {
        viewController
    }

    func updateUIViewController(_ uiViewController: ViewController, context: UIViewControllerRepresentableContext<UIViewControllerPreview<ViewController>>) {
    }
}

@available(iOS 13.0, *)
extension UIViewController {

    func preview() -> UIViewControllerPreview<UIViewController> {
        return UIViewControllerPreview { self }
    }
}

@available(iOS 13.0, *)
struct UIViewPreview<View: UIView>: UIViewRepresentable {
    let view: View

    init(_ builder: @escaping () -> View) {
        view = builder()
    }

    func makeUIView(context: Context) -> UIView {
        view
    }

    func updateUIView(_ view: UIView, context: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}

@available(iOS 13.0, *)
extension UIView {

    func preview() -> UIViewPreview<UIView> {
        return UIViewPreview { self }
    }
}

#endif
