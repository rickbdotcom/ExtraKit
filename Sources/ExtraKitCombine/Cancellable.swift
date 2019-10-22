//
//  Cancellable.swift
//  ERKit
//
//  Created by rickb on 7/3/19.
//  Copyright © 2019 vitaminshoppe. All rights reserved.
//

import Foundation

protocol Cancellable {
    func cancel()
}

final class AnyCancellable: Cancellable {

    let cancelBlock: () -> Void

    init(_ cancelBlock: @escaping () -> Void) {
        self.cancelBlock = cancelBlock
    }

    init<C: Cancellable>(_ cancellable: C) {
        self.cancelBlock = {
            cancellable.cancel()
        }
    }

    func cancel() {
        cancelBlock()
    }

    deinit {
        cancel()
    }
}
