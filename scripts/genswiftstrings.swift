import Foundation
import Utility

func main() {
	var inputPath: String!
	var outputPath: String!

	let arguments = Array(CommandLine.arguments.dropFirst())

	let parser = ArgumentParser(
		usage: "genswiftcolors --in <strings file path> --out <swift output file path>"
	, 	overview: "This tool generates strings from strings and stringsdict"
	)

	let inOpt = parser.add(option: "--in", shortName: nil, kind: String.self, usage: "path to strings file", completion: nil)
	let outOpt = parser.add(option: "--out", shortName: nil, kind: String.self, usage: "path to output swift source file", completion: nil)

	do {
		let result = try parser.parse(arguments)
		inputPath = result.get(inOpt)
		outputPath = result.get(outOpt)
	} catch {
		print("error: \(error)")
		return
	}

	autogeneratedLine()
	line("import UIKit")
	line()
	line("extension String {")
	line()
	let url = URL(fileURLWithPath: inputPath)
	if url.pathExtension == "strings" {
		strings(url)
	} else if url.pathExtension == "stringsdict" {
		formatStrings(url)
	}
	line("}")
	output(to: outputPath)
}

func strings(_ url: Foundation.URL) {
	let tmpPath = "/var/tmp/strings.plist"
	systemcommand(["/usr/bin/plutil", "-convert", "binary1", url.path, "-o", tmpPath])
	guard let stringsDict = NSDictionary(contentsOfFile: tmpPath)
	, stringsDict.count > 0 else {
		return
	}
	(stringsDict.allKeys as? [String])?.sorted{$0 < $1}.forEach {
		if $0.validSwiftString() {
			line("static let \($0) = \"\($0)\".localized()")
		}
	}
}

func formatStrings(_ url: Foundation.URL) {
	guard let stringsDict = NSDictionary(contentsOfFile: url.path)
	, stringsDict.count > 0 else {
		return
	}
	(stringsDict.allKeys as? [String])?.sorted{$0 < $1}.forEach {
		if $0.validSwiftString() {
			line("static let \($0) = \"\($0)\"")
		}
	}
}

func systemcommand(_ args: [String]) {
	let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.launch()
    task.waitUntilExit()
}

main()
