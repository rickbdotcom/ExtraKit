//
//
//  ExtraKit
//
//  Created by rickb on 7/9/19.
//  Copyright © 2019 rickbdotcom LLC. All rights reserved.
//

import Foundation

public final class Assign<Input, T: AnyObject>: Subscriber {

    private let receiveValue: (Input) -> Void

    init(_ object: T, _ keyPath: ReferenceWritableKeyPath<T, Input?>) {
        receiveValue = { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }

    init(_ object: T, _ keyPath: ReferenceWritableKeyPath<T, Input>) {
        receiveValue = { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }

    public func receive(subscription: Subscription) {
    }

    public func receive(_ input: Input) {
        receiveValue(input)
    }

    public func receive(error: Error) {
    }
}

public extension Publisher {

    func assign<T: AnyObject, Output>(_ object: T, _ keyPath: ReferenceWritableKeyPath<T, Output?>) -> AnyCancellable where Self.Output == Output {
        return subscribe(subscriber: Assign(object, keyPath))
    }

    func assign<T: AnyObject, Output>(_ object: T, _ keyPath: ReferenceWritableKeyPath<T, Output>) -> AnyCancellable where Self.Output == Output {
        return subscribe(subscriber: Assign(object, keyPath))
    }
}


