//
//
//  ExtraKit
//
//  Created by rickb on 7/9/19.
//  Copyright © 2019 rickbdotcom LLC. All rights reserved.
//

import Foundation
import PromiseKit

public protocol PaginatedPublisher: RefreshablePublisher {
	func nextPage() -> Promise<Void>
}

public final class PaginatedArrayPublisher<Element, Cursor>: DefaultSubjectImplementation<[Element]>, PaginatedPublisher {
	public typealias Output = [Element]

	private var currentValue: [Element]? {
		return paginatedArray.items
	}
	private let paginatedArray: PaginatedArray<Element, Cursor>

    init(cursor: Cursor, nextPage: @escaping (Cursor) -> Promise<([Element], Cursor?)>) {
		paginatedArray = PaginatedArray(cursor: cursor) { cursor in
			nextPage(cursor)
		}
    }

	public func refresh() -> Promise<[Element]> {
		paginatedArray.reset()
		return nextPage().map { [weak self] in
			guard let currentValue = self?.currentValue else {
				throw PMKError.cancelled
			}
			self?.send(value: currentValue)
			return currentValue
		}.recover { [weak self] error -> Promise<[Element]> in
		 	self?.send(error: error)
		 	throw error
		}
	}

    public func nextPage() -> Promise<Void> {
		return paginatedArray.fetchNextPage()
	}

    override public func receive<S: Subscriber>(subscriber: S) -> AnyCancellable where  Output == S.Input {
		let subscription = super.receive(subscriber: subscriber)
		if let currentValue = currentValue {
			send(value: currentValue)
		} else {
			refresh().cauterize()
		}
		return subscription
    }
}

public struct AnyPaginatedPublisher<Output>: PaginatedPublisher {

    private let receiveBlock: (AnySubscriber<Output>) -> AnyCancellable
    private let refreshBlock: () -> Promise<Output>
    private let nextPageBlock: () -> Promise<Void>

    init<P: PaginatedPublisher >(_ p: P) where P.Output == Output {
        receiveBlock = { s in
            p.receive(subscriber: s)
        }
        refreshBlock = {
            p.refresh()
        }
        nextPageBlock = {
			p.nextPage()
		}
    }

    public func receive<S>(subscriber s: S) -> AnyCancellable where S: Subscriber, Output == S.Input {
        return receiveBlock(AnySubscriber(s))
    }

	public func refresh() -> Promise<Output> {
		return refreshBlock()
    }

    public func nextPage() -> Promise<Void> {
		return nextPageBlock()
    }
}

public extension PaginatedPublisher {
    func typeErased() -> AnyPaginatedPublisher<Output> {
		return AnyPaginatedPublisher(self)
	}
}
