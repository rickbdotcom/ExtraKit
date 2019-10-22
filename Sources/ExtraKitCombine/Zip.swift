//
//
//  ExtraKit
//
//  Created by rickb on 7/9/19.
//  Copyright © 2019 rickbdotcom LLC. All rights reserved.
//  swiftlint:disable identifier_name

import Foundation
import PromiseKit

public struct Zip<A, B>: RefreshablePublisher where A: RefreshablePublisher, B: RefreshablePublisher {

    public typealias Output = (A.Output, B.Output)

    let a: A
    let b: B
    private let publisher: AnyPublisher<Output>
    private let aSubscription: Subscription?
    private let bSubscription: Subscription?

    init(_ a: A, _ b: B) {
        var aValue: A.Output?
        var bValue: B.Output?

        self.a = a
        self.b = b
        let subject = CurrentValueSubject<Output>()

        aSubscription = a.sink(receiveError: { error in
            subject.send(error: error)
        }, receiveValue: { value in
            aValue = value
            if let aValue = aValue, let bValue = bValue {
                subject.send(value: (aValue, bValue))
            }
        })

        bSubscription = b.sink(receiveError: { error in
            subject.send(error: error)
        }, receiveValue: { value in
            bValue = value
            if let aValue = aValue, let bValue = bValue {
                subject.send(value: (aValue, bValue))
            }
        })

        publisher = AnyPublisher(subject)
    }

    public func refresh() -> Promise<Output> {
        return when(fulfilled: a.refresh(), b.refresh())
    }

    public func receive<S>(subscriber: S) -> AnyCancellable where S: Subscriber, Output == S.Input {
        var aUpstreamSubscription = aSubscription
        var bUpstreamSubscription = bSubscription
        var publisherSubscription: AnyCancellable? = publisher.receive(subscriber: subscriber)
        return AnyCancellable {
            if aUpstreamSubscription != nil {
                aUpstreamSubscription = nil
            }
            if bUpstreamSubscription != nil {
                bUpstreamSubscription = nil
            }
            if publisherSubscription != nil {
                publisherSubscription = nil
            }
        }
    }
}
