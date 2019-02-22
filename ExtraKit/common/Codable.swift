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
