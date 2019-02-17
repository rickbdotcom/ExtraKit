import Foundation
import Utility

func main() {
	var inputPath: String!
	var outputPath: String!

	let arguments = Array(CommandLine.arguments.dropFirst())

	let parser = ArgumentParser(
		usage: "genswiftcolors --in <xcassets path> --out <swift output file path>"
	, 	overview: "This tool generates UIColor's from .xcasset named colors"
	)

	let inOpt = parser.add(option: "--in", shortName: nil, kind: String.self, usage: "path to xcassets", completion: nil)
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
	line("extension UIColor {")
	line()
	findFolders(extension: ["colorset"], in: inputPath).sorted { $0.lastPathComponent < $1.lastPathComponent }.forEach {
		color($0)
	}
	line("}")
	output(to: outputPath)
}

func color(_ url: Foundation.URL) {
	let color = url.deletingPathExtension().lastPathComponent
	outputString.addLine("\tstatic var \(color): UIColor { return UIColor(named: #function)! }")
}

main()
