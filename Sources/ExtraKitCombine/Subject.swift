//
//
//  ExtraKit
//
//  Created by rickb on 7/9/19.
//  Copyright © 2019 rickbdotcom LLC. All rights reserved.
//

import Foundation

public protocol Subject: AnyObject, Publisher {

    func send(value: Output)
    func send(error: Error)
}

public struct AnySubject<Output>: Publisher {

    private let receiveBlock: (AnySubscriber<Output>) -> AnyCancellable
    private let sendValueBlock: (Output) -> Void
    private let sendErrorBlock: (Error) -> Void

    init<P: Subject>(_ p: P) where P.Output == Output {
        receiveBlock = { s in
            p.receive(subscriber: s)
        }
        sendValueBlock = { value in
            p.send(value: value)
        }
        sendErrorBlock = { error in
            p.send(error: error)
        }
    }

    public func receive<S>(subscriber: S) -> AnyCancellable where S: Subscriber, Output == S.Input {
        return receiveBlock(AnySubscriber(subscriber))
    }

    func send(value: Output) {
		sendValueBlock(value)
	}

    func send(error: Error) {
		sendErrorBlock(error)
	}
}

public extension Subject {
    func typeErased() -> AnySubject<Output> {
		return AnySubject(self)
	}
}

public class CurrentValueSubject<Output>: DefaultSubjectImplementation<Output> {
	private(set) var currentValue: Output?
	private(set) var currentError: Error?

	override public func receive<S: Subscriber>(subscriber: S) -> AnyCancellable where Output == S.Input {
		let subscription = super.receive(subscriber: subscriber)
		if let currentValue = currentValue {
			subscriber.receive(currentValue)
		}
		if let currentError = currentError {
			subscriber.receive(error: currentError)
		}
		return subscription
    }

	override public func send(value: Output) {
		currentValue = value
		currentError = nil
		super.send(value: value)
	}

    override public func send(error: Error) {
		currentValue = nil
		currentError = error
		super.send(error: error)
	}
}

public class DefaultSubjectImplementation<Output>: Subject, Publisher {
	private var subscribers = [UUID: AnySubscriber<Output>]()

    public func receive<S: Subscriber>(subscriber: S) -> AnyCancellable where Output == S.Input {
        let subscriber = AnySubscriber(subscriber)
        subscribers[subscriber.identifier] = subscriber
        let subscription = AnyCancellable {
            self.subscribers[subscriber.identifier] = nil
        }
        subscriber.receive(subscription: subscription)
        return subscription
    }

    public func send(value: Output) {
        subscribers.values.forEach {
            $0.receive(value)
        }
    }

    public func send(error: Error) {
        subscribers.values.forEach {
            $0.receiveError?(error)
        }
    }
}
