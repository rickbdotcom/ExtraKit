//
//  PaginatedArray.swift
//  ExtraKit
//
//  Created by rickb on 4/17/19.
//  Copyright © 2019 rickbdotcom LLC. All rights reserved.
//

import Foundation
import PromiseKit

/// An array than can fetch pages of its content
public class PaginatedArray<T, Cursor> {

	var items: [T]?
	var cursor: Cursor?
	var initialCursor: Cursor

	private(set) var isLoading = false
	private var cancelToken: CancelToken?
	private let nextPage: (Cursor) -> Promise<([T], Cursor?)>

	init(cursor: Cursor, nextPage: @escaping (Cursor) -> Promise<([T], Cursor?)>) {
		self.initialCursor = cursor
		self.cursor = cursor
		self.nextPage = nextPage
	}

	func fetchNextPage() -> Promise<Void> {
		guard let cursor = self.cursor, isLoading == false else {
			return .cancelled()
		}
		isLoading = true

		weak var cancelToken = newCancelToken(&self.cancelToken)
		return nextPage(cursor).done { [weak self] items, cursor in
			try cancelToken.throwIfCancelled()
			self?.cursor = cursor
			self?.items = (self?.items ?? []) + items
		}.tap { [weak self] result in
			self?.pageLoadComplete(result)
		}
	}

	private func pageLoadComplete(_ result: PromiseKit.Result<Void>) {
		if isLoading == false || result.error?.isCancelled == true {
			return
		}
		isLoading = false
	}

	func canLoadNextPage() -> Bool {
		return cursor != nil && isLoading == false
	}

	func reset() {
		cursor = initialCursor
		items = nil
		isLoading = false
		newCancelToken(&self.cancelToken)
	}
}
