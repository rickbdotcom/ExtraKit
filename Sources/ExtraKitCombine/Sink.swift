//
//  Sink.swift
//  ExtraKit
//
//  Created by rickb on 7/3/19.
//  Copyright © 2019 rickbdotcom LLC. All rights reserved.
//

import Foundation

final class Sink<Input>: Subscriber {

    let receiveSubscription: ((Subscription) -> Void)?
    let receiveValue: (Input) -> Void
    let receiveError: ((Error) -> Void)?

    init(receiveSubscription: ((Subscription) -> Void)? = nil, receiveError: ((Error) -> Void)? = nil, receiveValue: @escaping (Input) -> Void) {
        self.receiveSubscription = receiveSubscription
        self.receiveValue = receiveValue
        self.receiveError = receiveError
    }

    func receive(subscription: Subscription) {
        receiveSubscription?(subscription)
    }

    func receive(_ input: Input) {
        receiveValue(input)
    }

    func receive(error: Error) {
        receiveError?(error)
    }
}

extension Publisher {

    func sink(receiveSubscription: ((Subscription) -> Void)? = nil, receiveError: ((Error) -> Void)? = nil, receiveValue: @escaping (Output) -> Void) -> AnyCancellable {
        return subscribe(subscriber: Sink(receiveSubscription: receiveSubscription, receiveError: receiveError, receiveValue: receiveValue))
    }
}
