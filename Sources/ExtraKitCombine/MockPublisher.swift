//
//
//  ExtraKit
//
//  Created by rickb on 7/9/19.
//  Copyright © 2019 rickbdotcom LLC. All rights reserved.
//

import Foundation

public func mockPublisher<T: Decodable>(named name: String, decoder: JSONDecoder = JSONDecoder(), bundle: Bundle = Bundle.main) -> AnyRefreshablePublisher<T>? {
	guard let url = bundle.url(forResource: name, withExtension: "json"),
	let data = try? Data(contentsOf: url),
	let object = try? decoder.decode(T.self, from: data)  else {
		return nil
	}
	return PromisePublisher { .value(object) }.typeErased()
}
