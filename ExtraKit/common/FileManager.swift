import Foundation

public extension FileManager {

	func temporaryFile(withExtension ext: String? = nil) -> URL {
		return temporaryDirectory.appendingPathComponent(UUID().uuidString + (ext.flatMap{".\($0)"} ?? ""))
	}
}
