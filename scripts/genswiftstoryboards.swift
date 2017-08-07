#!/usr/bin/env xcrun --sdk macosx swift

// swiftlint:disable cyclomatic_complexity

import Foundation

let outputPath = CommandLine.arguments[1]
let structName = CommandLine.arguments[2]

var tabs = 0

extension String {
	mutating func addLine(_ line: String = "") {
		
		if line.characters.last == "}" {
			tabs -= 1
		}
		if tabs > 0 {
			self += String(repeating: "\t", count: tabs)
		}

		self += "\(line)\n"

		if line.characters.last == "{" {
			tabs += 1
		}
	}

	func uncapitalized() -> String {
		return replacingCharacters(in: startIndex..<index(startIndex, offsetBy:1), with: self[startIndex...startIndex].lowercased())
	}
}

func validSwiftString(_ string: String) -> Bool {
	guard !string.isEmpty else {
		return false
	}
	let invalidSet = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_")).inverted
	if string.rangeOfCharacter(from: invalidSet) != nil {
		return false
	}
	if let first = string.unicodeScalars.first, CharacterSet.decimalDigits.contains(first) {
		return false
	}
	return true
}

var outputString = ""

outputString.addLine("// autogenerated by genswiftstoryboards.swift")
outputString.addLine("")
outputString.addLine("import UIKit")
outputString.addLine("import ExtraKit")
outputString.addLine("")

func generateStoryboardIdentifierSourceFile(_ path: String) {
	do {
		let url = URL(fileURLWithPath: path)
#if swift(>=4.0)
		let doc = try XMLDocument(contentsOf: url, options: [])
#else
		let doc = try XMLDocument(contentsOf: url, options: 0)
#endif
		var vcs = [XMLElement]()
		if let cs = try doc.nodes(forXPath:"//viewController") as? [XMLElement] {
			vcs.append(contentsOf: cs)
		}
		if let cs = try doc.nodes(forXPath:"//tableViewController") as? [XMLElement] {
			vcs.append(contentsOf: cs)
		}
		if let cs = try doc.nodes(forXPath:"//tabBarController") as? [XMLElement] {
			vcs.append(contentsOf: cs)
		}
		if let cs = try doc.nodes(forXPath:"//navigationController") as? [XMLElement] {
			vcs.append(contentsOf: cs)
		}
		if let cs = try doc.nodes(forXPath:"//splitViewController") as? [XMLElement] {
			vcs.append(contentsOf: cs)
		}
		if let cs = try doc.nodes(forXPath:"//viewControllerPlaceholder") as? [XMLElement] {
			vcs.append(contentsOf: cs)
		}
		if let cs = try doc.nodes(forXPath:"//collectionViewController") as? [XMLElement] {
			vcs.append(contentsOf: cs)
		}
		guard vcs.count > 0 else {
			return
		}
		
		let ids: [(storyboardIdentifier: String, id: String, segues: [String])]! = vcs.flatMap { svc in
			if let storyboardIdentifier = svc.attribute(forName:"storyboardIdentifier")?.stringValue,
				let id = svc.attribute(forName:"id")?.stringValue {
				var segues = [String]()
				if let segueNodes = try? svc.nodes(forXPath:"..//segue") {
					segueNodes.forEach {
						if let elem = ($0 as? XMLElement),
							let identifier = elem.attribute(forName:"identifier")?.stringValue,
							!identifier.isEmpty {
							segues.append(identifier)
						}
					}
				}
				return (storyboardIdentifier, id, segues)
			}
			return nil
		}
		guard ids.isEmpty == false else { return }
		
		let fileName = url.deletingPathExtension().lastPathComponent
		if validSwiftString(fileName) {
			outputString.addLine("struct \(fileName) {")
			outputString.addLine()
			
			ids.forEach {
				if validSwiftString($0.storyboardIdentifier) {
					outputString.addLine("struct \($0.storyboardIdentifier): StoryboardScene {")

					if !$0.segues.isEmpty {
						outputString.addLine("struct Segues {")
						$0.segues.forEach { segue in
							if validSwiftString(segue) {
								outputString.addLine("let \(segue.uncapitalized()) = \"\(segue)\"")
							}
						}
						outputString.addLine("}")
					}
					outputString.addLine("let identifier = (\"\($0.storyboardIdentifier)\", \"\(fileName)\")")
					outputString.addLine("}")
				}
			}

			outputString.addLine("}")
		}
		outputString.addLine()
	} catch _ {

	}
}

outputString += "/**\n"
outputString += "\tGenerated from the storyboards used by the app.\n"
outputString += "\tUsage: \(structName).<StoryboardName>.<StoryboardId>.Segues().<SegueIdentifier>\n"
outputString += "\tUsage: \(structName).<StoryboardName>.<StoryboardId>().instantiateViewController()\n"
outputString += "*/\n"
outputString.addLine("struct \(structName) {")
outputString.addLine("")
CommandLine.arguments[3..<CommandLine.arguments.count].forEach {
	generateStoryboardIdentifierSourceFile($0)
}
outputString.addLine("}")

try? outputString.write(toFile:outputPath, atomically: true, encoding: String.Encoding.utf8)