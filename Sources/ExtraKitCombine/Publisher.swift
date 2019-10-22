//
//
//  ExtraKit
//
//  Created by rickb on 7/9/19.
//  Copyright © 2019 rickbdotcom LLC. All rights reserved.
//  swiftlint:disable identifier_name

import Foundation
import PromiseKit

public protocol Publisher {
    associatedtype Output

    func receive<S: Subscriber>(subscriber: S) -> AnyCancellable where  Output == S.Input
}

public struct AnyPublisher<Output>: Publisher {

	private let receiveBlock: (AnySubscriber<Output>) -> AnyCancellable

	public init<P: Publisher>(_ p: P) where P.Output == Output {
		receiveBlock = { s in
			p.receive(subscriber: s)
		}
	}

	public func receive<S>(subscriber: S) -> AnyCancellable where S: Subscriber, Output == S.Input {
		return receiveBlock(AnySubscriber(subscriber))
	}
}

public extension Publisher {

	func typeErased() -> AnyPublisher<Output> {
		return AnyPublisher(self)
	}
}

public extension Publisher {

	func once() -> Promise<Output> {
		var subscription: Subscription?
		return Promise { seal in
			subscription = sink(receiveError: {
				seal.reject($0)
				if subscription != nil {
					subscription = nil
				}
			}, receiveValue: {
				seal.fulfill($0)
				if subscription != nil {
					subscription = nil
				}
			})
		}
	}
}
