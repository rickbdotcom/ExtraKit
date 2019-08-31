//
//  HandleEvents.swift
//  ExtraKit
//
//  Created by rickb on 7/13/19.
//  Copyright © 2019 rickbdotcom LLC. All rights reserved.
//

import Foundation

struct HandleEvents<Upstream>: Publisher where Upstream: Publisher {
    typealias Output = Upstream.Output

    let upstream: Upstream
    var receiveSubscription: ((Subscription) -> Void)?
    var receiveOutput: ((Output) -> Void)?
    var receiveError: ((Error) -> Void)?

    init(upstream: Upstream, receiveSubscription: ((Subscription) -> Void)? = nil, receiveOutput: ((Output) -> Void)? = nil, receiveError: ((Error) -> Void)? = nil) {
        self.upstream = upstream
        self.receiveSubscription = receiveSubscription
        self.receiveOutput = receiveOutput
        self.receiveError = receiveError
    }

    func receive<S>(subscriber: S) -> AnyCancellable where S: Subscriber, Output == S.Input {
        let subscriber = AnySubscriber<Output>(receiveSubscription: { subscription in
            self.receiveSubscription?(subscription)
            subscriber.receive(subscription: subscription)
        }, receiveInput: { input in
            self.receiveOutput?(input)
            subscriber.receive(input)
        }, receiveError: { error in
            self.receiveError?(error)
            subscriber.receive(error: error)
        })
        return upstream.subscribe(subscriber: subscriber)
    }
}

extension Publisher {

    func handleEvents(receiveSubscription: ((Subscription) -> Void)? = nil, receiveOutput: ((Output) -> Void)? = nil, receiveError: ((Error) -> Void)? = nil) -> HandleEvents<Self> {
        return HandleEvents(upstream: self, receiveSubscription: receiveSubscription, receiveOutput: receiveOutput, receiveError: receiveError)
    }
}
