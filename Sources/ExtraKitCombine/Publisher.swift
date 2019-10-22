//
//  Publisher.swift
//  ERKit
//
//  Created by rickb on 6/30/19.
//  Copyright © 2019 vitaminshoppe. All rights reserved.
//  swiftlint:disable identifier_name

import Foundation
import PromiseKit

protocol Publisher {
    associatedtype Output

    func receive<S: Subscriber>(subscriber: S) -> AnyCancellable where  Output == S.Input
}

struct AnyPublisher<Output>: Publisher {

    private let receiveBlock: (AnySubscriber<Output>) -> AnyCancellable

    init<P: Publisher>(_ p: P) where P.Output == Output {
        receiveBlock = { s in
            p.receive(subscriber: s)
        }
    }

    func receive<S>(subscriber: S) -> AnyCancellable where S: Subscriber, Output == S.Input {
        return receiveBlock(AnySubscriber(subscriber))
    }
}

extension Publisher {

    func typeErased() -> AnyPublisher<Output> {
        return AnyPublisher(self)
    }
}

extension Publisher {

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
