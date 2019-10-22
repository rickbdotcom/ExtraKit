//
//  Subscriber.swift
//  ERKit
//
//  Created by rickb on 7/3/19.
//  Copyright © 2019 vitaminshoppe. All rights reserved.
//  swiftlint:disable identifier_name

import Foundation

protocol Subscriber {
    associatedtype Input

    func receive(subscription: Subscription)
    func receive(_ input: Input)
    func receive(error: Error)
}

typealias Subscription = Cancellable

struct AnySubscriber<Input>: Subscriber {

    let identifier = UUID()
    let receiveSubscription: ((Subscription) -> Void)?
    let receiveInput: ((Input) -> Void)?
    let receiveError: ((Error) -> Void)?

    func receive(subscription: Subscription) {
        receiveSubscription?(subscription)
    }

    func receive(_ input: Input) {
        receiveInput?(input)
    }

    func receive(error: Error) {
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

extension Publisher {

    func subscribe<S: Subscriber>(subscriber: S) -> AnyCancellable where Output == S.Input {
        return receive(subscriber: subscriber)
    }
}

struct SubscriptionValue<T> {
	var value: T?
	var subscription: Subscription?
}
