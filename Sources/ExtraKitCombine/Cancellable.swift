//
//
//  ExtraKit
//
//  Created by rickb on 7/9/19.
//  Copyright © 2019 rickbdotcom LLC. All rights reserved.
//

import Foundation

public protocol Cancellable {
    func cancel()
}

public final class AnyCancellable: Cancellable {

    let cancelBlock: () -> Void

    init(_ cancelBlock: @escaping () -> Void) {
        self.cancelBlock = cancelBlock
    }

    init<C: Cancellable>(_ cancellable: C) {
        self.cancelBlock = {
            cancellable.cancel()
        }
    }

    public func cancel() {
        cancelBlock()
    }

    deinit {
        cancel()
    }
}
