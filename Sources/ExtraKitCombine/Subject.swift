//
//  Subject.swift
//  ERKit
//
//  Created by rickb on 7/3/19.
//  Copyright © 2019 vitaminshoppe. All rights reserved.
//

import Foundation

protocol Subject: AnyObject, Publisher {

    func send(value: Output)
    func send(error: Error)
}

final class CurrentValueSubject<T>: Subject, DefaultPublisherImplementation {
	typealias Output = T

	var subscribers = [UUID: AnySubscriber<Output>]()
	private var currentValue: Output?

	func receive<S: Subscriber>(subscriber: S) -> AnyCancellable where Output == S.Input {
		let subscription = defaultReceive(subscriber: subscriber)
		if let currentValue = currentValue {
			subscriber.receive(currentValue)
		}
		return subscription
    }

    func send(value: Output) {
		currentValue = value
		subscribers.values.forEach {
			$0.receive(value)
		}
	}
}
