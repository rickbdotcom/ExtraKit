#!/usr/bin/env xcrun --sdk macosx swift

// genswift.sh --nibs-dir ./ --nibs-src Catapult/App/Nibs.swift --nibs-import none

import Foundation

let outputPath = CommandLine.arguments[1]
let imports = CommandLine.arguments[2]

var tabs = 0

extension String {
	mutating func addLine(_ line: String = "") {
		
		if line.suffix(1) == "}" {
			tabs -= 1
		}
		if tabs > 0 {
			self += String(repeating: "\t", count: tabs)
		}

		self += "\(line)\n"

		if line.suffix(1) == "{" {
			tabs += 1
		}
	}

	func uncapitalized() -> String {
		return replacingCharacters(in: startIndex..<index(startIndex, offsetBy:1), with: self[startIndex...startIndex].lowercased())
	}
}

var outputString = ""

outputString.addLine("""
// autogenerated by genswiftstoryboards.swift

import UIKit
import ExtraKit
""")

imports.components(separatedBy: " ").filter {
	$0 != "none"
}.forEach {
	outputString.addLine("import \($0)")
}
outputString.addLine("")

func generateNibDescription(_ path: String) {
	do {
		let url = URL(fileURLWithPath: path)
		let doc = try XMLDocument(contentsOf: url, options: [])

		let nibName = path.components(separatedBy: "/").last!.components(separatedBy: ".").first!
		let varName = "nib\(nibName)"

		var ownerClass = "NSObject"
		var topClass = "NSObject"

		if let elem = (try doc.nodes(forXPath:"//placeholder") as? [XMLElement])?.first {
			if let customClass = elem.attribute(forName:"customClass")?.stringValue {
				ownerClass = customClass
			}
		}
		if let elem = (try doc.nodes(forXPath:"//collectionViewCell") as? [XMLElement])?.first {
			topClass = "UICollectionViewCell"
			if let customClass = elem.attribute(forName:"customClass")?.stringValue {
				topClass = customClass
			}
		} else if let elem = (try doc.nodes(forXPath:"//tableViewCell") as? [XMLElement])?.first {
			topClass = "UITableViewCell"
			if let customClass = elem.attribute(forName:"customClass")?.stringValue {
				topClass = customClass
			}
		} else if let elem = (try doc.nodes(forXPath:"//view") as? [XMLElement])?.first {
			topClass = "UIView"
			if let customClass = elem.attribute(forName:"customClass")?.stringValue {
				topClass = customClass
			}
		}

		outputString.addLine("""
		let \(varName) = NibDescription(nibName: "\(nibName)", ownerClass: \(ownerClass).self, topLevelObjectClass: \(topClass).self)
		""")
	} catch {

	}
}

outputString += """
/**
	Generated from the nibs used by the app.
*/

"""
outputString.addLine("")
CommandLine.arguments[3..<CommandLine.arguments.count].sorted { $0 < $1 }.forEach {
	generateNibDescription($0)
}

outputString.addLine("")

try? outputString.write(toFile:outputPath, atomically: true, encoding: String.Encoding.utf8)
