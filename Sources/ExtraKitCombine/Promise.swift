//
//  Promise.swift
//  
//
//  Created by rickb on 10/21/19.
//

import Foundation
import PromiseKit

public extension Promise {

	static func void() -> Promise<Void> {
		return .value(())
	}

	static func `nil`<T>() -> Promise<T?> {
		return .value(nil)
	}

	static func empty<T>() -> Promise<[T]> {
		return .value([])
	}

	static func cancelled() -> Promise<T> {
		return Promise(error: PMKError.cancelled)
	}
}

public extension Promise {

	func notification(onBegin: Notification.Name? = nil, objectBegin: Any? = nil, beginUserInfo: [AnyHashable : Any]? = nil, onEnd: Notification.Name? = nil, objectEnd: Any? = nil, endUserInfo: [AnyHashable: Any]? = nil) -> Promise {
		let begin = onBegin.flatMap { Notification(name: $0, object: objectBegin, userInfo: beginUserInfo) }
		let end = onEnd.flatMap { Notification(name: $0, object: objectEnd, userInfo: endUserInfo) }
		return notification(onBegin: begin, onEnd: end)
	}

	func notification(onBegin: Notification? = nil, onEnd: Notification? = nil) -> Promise {
		if let begin = onBegin {
			NotificationCenter.default.post(begin)
		}
		return ensure {
			if let end = onEnd {
				NotificationCenter.default.post(end)
			}
		}
	}
}

public protocol CancelTokenProtocol {

	var isCancelled: Bool { get }

	func cancel()

	init()
}

public extension CancelTokenProtocol {

	func throwIfCancelled() throws {
		if isCancelled {
			throw PMKError.cancelled
		}
	}
}

public final class SemaphoreCancelToken: CancelTokenProtocol {

	private let semaphore = DispatchSemaphore(value: 0)
	public private(set) var isCancelled = false

	public func cancel() {
		isCancelled = true
		semaphore.signal()
	}

	public func wait() {
		semaphore.wait()
	}

	public func signal() {
		semaphore.signal()
	}

	public init() {}

	deinit {
		semaphore.signal()
	}
}

public func wait() -> (Promise<Void>, SemaphoreCancelToken) {
	let cancelToken = SemaphoreCancelToken()
	let (promise, seal) = Promise<Void>.pending()

	DispatchQueue.global().async { [weak cancelToken] in
		cancelToken?.wait()
		if cancelToken.isCancelled {
			seal.reject(PMKError.cancelled)
		} else {
			seal.fulfill(())
		}
	}
	return (promise, cancelToken)
}

public final class CancelToken: CancelTokenProtocol {

	public private(set) var isCancelled = false

	public func cancel() {
		isCancelled = true
	}

	public init() { }
}

public extension Optional where Wrapped: CancelTokenProtocol {

/// CancelToken is often accessed through its Optional so we can throw when weak reference is nil'ed out.
/// This method throws if CancelToken has be cancelled or weak reference is nil'ed out, for use in Promise body.
	func throwIfCancelled() throws {
		switch self {
		case .none:
			throw PMKError.cancelled
		case .some(let token):
			try token.throwIfCancelled()
		}
	}

	var isCancelled: Bool {
		return self?.isCancelled ?? true
	}
}

/// Cancel current token and assign a new value
@discardableResult
public func newCancelToken<T: CancelTokenProtocol>(_ token: inout T?) -> T? {
	token?.cancel()
	token = T()
	return token
}

public extension PromiseKit.Result {

	var value: T? {
		if case let .fulfilled(value) = self {
			return value
		}
		return nil
	}

	var error: Error? {
		if case let .rejected(error) = self {
			return error
		}
		return nil
	}
}
