//
//
//  ExtraKit
//
//  Created by rickb on 7/9/19.
//  Copyright © 2019 rickbdotcom LLC. All rights reserved.
//  swiftlint:disable identifier_name

import Foundation

public protocol Subscriber {
    associatedtype Input

    func receive(subscription: Subscription)
    func receive(_ input: Input)
    func receive(error: Error)
}

public typealias Subscription = Cancellable

public struct AnySubscriber<Input>: Subscriber {

	let identifier = UUID()
    let receiveSubscription: ((Subscription) -> Void)?
    let receiveInput: ((Input) -> Void)?
    let receiveError: ((Error) -> Void)?

    public func receive(subscription: Subscription) {
        receiveSubscription?(subscription)
    }

    public func receive(_ input: Input) {
        receiveInput?(input)
    }

    public func receive(error: Error) {
        receiveError?(error)
    }

    init(receiveSubscription: ((Subscription) -> Void)? = nil, receiveInput: ((Input) -> Void)? = nil, receiveError: ((Error) -> Void)? = nil) {
        self.receiveSubscription = receiveSubscription
        self.receiveInput = receiveInput
        self.receiveError = receiveError
    }

    init<S: Subscriber>(_ s: S) where Input == S.Input {
        receiveSubscription = {
            s.receive(subscription: $0)
        }
        receiveInput = {
            s.receive($0)
        }
        receiveError = {
            s.receive(error: $0)
        }
    }
}

public extension Publisher {

    func subscribe<S: Subscriber>(subscriber: S) -> AnyCancellable where Output == S.Input {
        return receive(subscriber: subscriber)
    }
}

public struct SubscriptionValue<T> {
	var value: T?
	var subscription: Subscription?
}

