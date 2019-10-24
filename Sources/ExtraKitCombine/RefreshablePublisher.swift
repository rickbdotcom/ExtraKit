//
//
//  ExtraKit
//
//  Created by rickb on 7/9/19.
//  Copyright © 2019 rickbdotcom LLC. All rights reserved.
//  swiftlint:disable identifier_name

import Foundation
import PromiseKit

public protocol RefreshablePublisher: Publisher {
	func refresh() -> Promise<Output>
}

public final class PromisePublisher<Output>: DefaultSubjectImplementation<Output>, RefreshablePublisher {
	private let request: () -> Promise<Output>
	private var currentValue: Output?
	private let refreshResolver = ResolverArray<Output>()

	public init(request: @escaping () -> Promise<Output>) {
		self.request = request
	}

	public func refresh() -> Promise<Output> {
		if refreshResolver.isEmpty {
			return request()
				.tap { [weak self] result in
					switch result {
					case let .fulfilled(value):
						self?.currentValue = value
						self?.send(value: value)
					case let .rejected(error):
						self?.currentValue = nil
						self?.send(error: error)
					}
				}
				.resolve(with: refreshResolver)
		} else {
			return refreshResolver.add()
		}
	}

	override public func receive<S: Subscriber>(subscriber: S) -> AnyCancellable where  Output == S.Input {
		let subscription = super.receive(subscriber: subscriber)
		if let currentValue = currentValue {
			subscriber.receive(currentValue)
		} else {
			refresh().cauterize()
		}
		return subscription
	}
}

public struct AnyRefreshablePublisher<Output>: RefreshablePublisher {

	private let receiveBlock: (AnySubscriber<Output>) -> AnyCancellable
	private let refreshBlock: () -> Promise<Output>

	public init<P: RefreshablePublisher>(_ p: P) where P.Output == Output {
		receiveBlock = { s in
			p.receive(subscriber: s)
		}
		refreshBlock = {
			p.refresh()
		}
	}

	public func receive<S>(subscriber s: S) -> AnyCancellable where S: Subscriber, Output == S.Input {
		return receiveBlock(AnySubscriber(s))
	}

	public func refresh() -> Promise<Output> {
		return refreshBlock()
	}
}

public extension RefreshablePublisher {

	func typeErased() -> AnyRefreshablePublisher<Output> {
		return AnyRefreshablePublisher(self)
	}
}