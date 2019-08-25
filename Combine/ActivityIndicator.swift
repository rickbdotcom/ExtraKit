//
//  ActivityIndicator.swift
//  ExclusiveResorts
//
//  Created by rickb on 6/29/19.
//  Copyright © 2019 Bottle Rocket Studios. All rights reserved.
//

import ERKit
import Foundation
import PromiseKit

protocol ActivityIndicator {

    func startActivity(context: [String: Any]?)
    func stopActivity(context: [String: Any]?)
}

extension UIActivityIndicatorView: ActivityIndicator {

    func startActivity(context: [String: Any]?) {
        startAnimating()
    }

    func stopActivity(context: [String: Any]?) {
        stopAnimating()
    }
}

extension UIRefreshControl: ActivityIndicator {

	private var subscription: Cancellable? {
		get { return associatedValue() }
		set { set(associatedValue: newValue) }
	}

    func startActivity(context: [String: Any]?) {
        beginRefreshing()
        if let scrollView = superview as? UIScrollView {
            scrollView.contentOffset.y = -scrollView.contentInset.top
        }
    }

    func stopActivity(context: [String: Any]?) {
        endRefreshing()
    }

    convenience init?<T: RefreshablePublisher>(with refreshable: T?) {
        guard let refreshable = refreshable else {
            return nil
        }
        self.init(frame: .zero)
        on(.valueChanged) { _ in
            refreshable.refresh().cauterize()
        }
        subscription = refreshable.sink(receiveError: { [weak self] _ in
			self?.stopActivity()
		}, receiveValue: { [weak self] _ in
			self?.stopActivity()
		})
    }
}

extension Promise {

    func showActivity(with indicator: ActivityIndicator?, context: [String: Any]? = nil) -> Promise {
        indicator?.startActivity(context: context)
        return ensure {
            indicator?.stopActivity(context: context)
        }
    }

    func showActivityWithIndicator(in view: UIView, context: [String: Any]? = nil) -> Promise {
        let indicator = UIActivityIndicatorView(style: .gray).add(to: view).center()
        return showActivity(with: indicator).ensure {
            indicator.removeFromSuperview()
        }
    }
}

extension Publisher {

    func showActivity(with indicator: ActivityIndicator?, context: [String: Any]? = nil) -> AnyPublisher<Output> {
        return AnyPublisher(handleEvents(receiveSubscription: { _ in
            indicator?.startActivity(context: context)
        }, receiveOutput: { _ in
            indicator?.stopActivity(context: context)
        }, receiveError: { _ in
            indicator?.stopActivity(context: context)
        }))
    }

    func showActivityWithIndicator(in view: UIView, context: [String: Any]? = nil) -> AnyPublisher<Output> {
        var indicator: UIActivityIndicatorView? = UIActivityIndicatorView(style: .gray).add(to: view).center()

        return AnyPublisher(showActivity(with: indicator).handleEvents(receiveOutput: { _ in
            indicator?.removeFromSuperview()
            indicator = nil
        }, receiveError: { _ in
            indicator?.removeFromSuperview()
            indicator = nil
        }))
    }
}
