//
//  FileManager.swift
//  ExtraKit
//
//  Created by rickb on 4/18/16.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

import Foundation

public extension FileManager {

	@available(iOS 10.0, *)
	func temporaryFile(withExtension ext: String? = nil) -> URL {
		return temporaryDirectory.appendingPathComponent(UUID().uuidString + (ext.flatMap{".\($0)"} ?? ""))
	}
}
