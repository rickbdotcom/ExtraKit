//
//
//  ExtraKit
//
//  Created by rickb on 7/9/19.
//  Copyright © 2019 rickbdotcom LLC. All rights reserved.
//

import Foundation
import PromiseKit

public class ResolverArray<T> {

	private var resolvers = [Resolver<T>]()

	public var isEmpty: Bool { return resolvers.isEmpty }

	public init() { }

	public func add() -> Promise<T> {
		let (promise, seal) = Promise<T>.pending()
		resolvers.append(seal)
		return promise
	}

	public func fulfill(_ value: T) {
		resolvers.forEach {
			$0.fulfill(value)
		}
		resolvers = []
	}

	public func reject(_ error: Error) {
		resolvers.forEach {
			$0.reject(error)
		}
		resolvers = []
	}

	public func resolve(_ result: PromiseKit.Result<T>) {
		resolvers.forEach {
			$0.resolve(result)
		}
		resolvers = []
	}

	deinit {
		reject((PMKError.cancelled))
	}
}

public extension Promise {

	@discardableResult
	func resolve(with resolvers: ResolverArray<T>) -> Promise {
		tap {
			resolvers.resolve($0)
		}.cauterize()
		return resolvers.add()
	}
}
