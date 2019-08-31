//
//
//  ExtraKit
//
//  Created by rickb on 4/18/16.
//  Copyright © 2018 rickbdotcom LLC. All rights reserved.
//

import Foundation

public extension Decodable {

	static func from(json: Any, decoder: JSONDecoder = JSONDecoder()) -> Self? {
		if let data = try? JSONSerialization.data(withJSONObject: json, options: []) {
			return try? decoder.decode(self, from: data)
		}
		return nil
	}
}

public extension Encodable {

	func toJSON(encoder: JSONEncoder = JSONEncoder()) -> Any? {
		if let data = try? encoder.encode(self)
		, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
			return json
		}
		return nil
	}
}

public extension Decoder {

    func defaultDecodeIfPresent(_ keyPath: String, _ default: String = "") -> String {
        return defaultDecodeIfPresent(keyPath, as: String.self, `default`)
    }

    func defaultDecodeIfPresent(_ keyPath: String, _ default: Int = 0) -> Int {
        return defaultDecodeIfPresent(keyPath, as: Int.self, `default`)
    }

    func defaultDecodeIfPresent(_ keyPath: String, _ default: Bool = false) -> Bool {
        return defaultDecodeIfPresent(keyPath, as: Bool.self, `default`)
    }

    func defaultDecodeIfPresent(_ keyPath: String, _ default: Double = 0.0) -> Double {
        return defaultDecodeIfPresent(keyPath, as: Double.self, `default`)
    }

    func defaultDecodeIfPresent(_ keyPath: String, _ default: Int64 = 0) -> Int64 {
        return defaultDecodeIfPresent(keyPath, as: Int64.self, `default`)
    }

    func defaultDecodeIfPresent<T: Decodable>(_ keyPath: String, _ default: [T] = []) -> [T] {
        return defaultDecodeIfPresent(keyPath, as: [T].self, `default`)
    }

    func defaultDecodeIfPresent<T: Decodable>(_ keyPath: String, as type: T.Type = T.self, _ default: T? = nil) -> T? {
        return (try? decodeIfPresent(keyPath: keyPath, as: type) ?? `default`) ?? `default`
    }

    func defaultDecodeIfPresent<T: Decodable>(_ keyPath: String, as type: T.Type = T.self, _ default: T) -> T {
        return (try? decodeIfPresent(keyPath: keyPath, as: type) ?? `default`) ?? `default`
    }

	func decodeIfPresent<T: Decodable>(keyPath: String, as type: T.Type = T.self) throws -> T? {
		var container: AnyDecodingContainer? = self.container()
		let keys = keyPath.components(separatedBy: ".")
		try keys.dropLast().forEach { key in
			container = try container?.nestedContainer(forKey: key)
		}
		if let container = container, let key = keys.last {
			return try container.decodeIfPresent(type, forKey: key)
		}
		return nil
	}
}

enum AnyDecodingContainer {

	case keyed(_: KeyedDecodingContainer<AnyCodingKey>)
	case unkeyed(_: UnkeyedDecodingContainer)
	case single(_: SingleValueDecodingContainer)

	func nestedContainer(forKey key: String) throws -> AnyDecodingContainer? {
		switch self {
		case let .keyed(container):
			return container.nestedContainer(forKey: key)
		case let .unkeyed(container):
			return container.nestedContainer(forKey: key)
		default:
			return nil
		}
	}

	func decodeIfPresent<T: Decodable>(_ type: T.Type, forKey key: String) throws -> T? {
		switch self {
		case let .keyed(container):
			return try container.decodeIfPresent(type, forKey: AnyCodingKey(key))
		case let .unkeyed(container):
			guard let index = Int(key) else {
				return nil
			}
			var unkeyedContainer = container
			if index > 0 {
				for _ in 0..<index-1 {
					_ = try unkeyedContainer.decode(type)
				}
			}
			return try unkeyedContainer.decode(type)
		case let .single(container):
			return try container.decode(type)
		}
	}
}

extension UnkeyedDecodingContainer {

	func nestedContainer(forKey key: String) -> AnyDecodingContainer? {
		guard let index = Int(key) else {
			return nil
		}
		var unkeyedContainer = self
		if index > 0 {
			for _ in 0..<index-1 {
				_ = try? unkeyedContainer.nestedContainer(keyedBy: AnyCodingKey.self)
			}
		}
		if let container = try? unkeyedContainer.nestedContainer(keyedBy: AnyCodingKey.self) {
			return .keyed(container)
		}
		unkeyedContainer = self
		if index > 0 {
			for _ in 0..<index-1 {
				_ = try? unkeyedContainer.nestedUnkeyedContainer()
			}
		}
		if let container = try? unkeyedContainer.nestedUnkeyedContainer() {
			return .unkeyed(container)
		}
		return nil
	}
}

extension KeyedDecodingContainer where K == AnyCodingKey{

	func nestedContainer(forKey key: String) -> AnyDecodingContainer? {
		if let container = try? nestedContainer(keyedBy: AnyCodingKey.self, forKey: AnyCodingKey(key)) {
			return .keyed(container)
		}
		if let container = try? nestedUnkeyedContainer(forKey: AnyCodingKey(key)) {
			return .unkeyed(container)
		}
		return nil
	}
}

extension Decoder {

	func container() -> AnyDecodingContainer? {
		if let container = try? self.container(keyedBy: AnyCodingKey.self) {
			return .keyed(container)
		}
		if let container = try? self.unkeyedContainer() {
			return .unkeyed(container)
		}
		if let container = try? self.singleValueContainer() {
			return .single(container)
		}
		return nil
	}
}
