//
//  Publisher.swift
//  ExtraKit
//
//  Created by rickb on 6/30/19.
//  Copyright © 2019 rickbdotcom LLC. All rights reserved.
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

protocol DefaultPublisherImplementation: AnyObject, Publisher {
    var subscribers: [UUID: AnySubscriber<Output>] { get set }
}

extension DefaultPublisherImplementation {

    func defaultReceive<S: Subscriber>(subscriber: S) -> AnyCancellable where  Output == S.Input {
        let subscriber = AnySubscriber(subscriber)
        subscribers[subscriber.identifier] = subscriber
        let subscription = AnyCancellable {
            self.subscribers[subscriber.identifier] = nil
        }
        subscriber.receive(subscription: subscription)
        return subscription
    }

    func receive<S: Subscriber>(subscriber: S) -> AnyCancellable where Output == S.Input {
        return defaultReceive(subscriber: subscriber)
    }

    func send(value: Output) {
        subscribers.values.forEach {
            $0.receive(value)
        }
    }

    func send(error: Error) {
        subscribers.values.forEach {
            $0.receiveError?(error)
        }
    }
}

extension Publisher {

	func once() -> Promise<Output> {
		var subscription: Cancellable?
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
