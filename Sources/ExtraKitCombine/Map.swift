//
//  Map.swift
//  vitaminshoppe
//
//  Created by rickb on 9/5/19.
//  Copyright © 2019 vitaminshoppe. All rights reserved.
//

import Foundation
import PromiseKit

struct MapOutput<Upstream, Output>: RefreshablePublisher where Upstream: Publisher {

    let upstream: Upstream
    let transform: (Upstream.Output) -> Output
    private let publisher: AnyPublisher<Output>
    private let subscription: Subscription?

    init(upstream: Upstream, transform: @escaping (Upstream.Output) -> Output) {
        self.upstream = upstream
        self.transform = transform

        let subject = CurrentValueSubject<Output>()

        subscription = upstream.sink(receiveError: { error in
            subject.send(error: error)
        }, receiveValue: { value in
            subject.send(value: transform(value))
        })

        publisher = AnyPublisher(subject)
    }

    func receive<S: Subscriber>(subscriber: S) -> AnyCancellable where  Output == S.Input {
        var upstreamSubscription = subscription
        var publisherSubscription: AnyCancellable? = publisher.receive(subscriber: subscriber)
        return AnyCancellable {
            if upstreamSubscription != nil {
                upstreamSubscription = nil
            }
            if publisherSubscription != nil {
                publisherSubscription = nil
            }
        }
    }

    func refresh() -> Promise<Output> {
		return .cancelled()
	}
}

extension MapOutput where Upstream: RefreshablePublisher {
    func refresh() -> Promise<Output> {
		return upstream.refresh().map { self.transform($0) }
	}
}

extension Publisher {

    func map<Output>(_ transform: @escaping (Self.Output) -> Output) -> MapOutput<Self, Output> {
        return MapOutput(upstream: self, transform: transform)
    }
}
