//
// Created by chchrn on 6/10/20.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation
import Promises

public class SqsFailExecutor: SqsExecutor {
    public enum FailError: Error {
        case undefined
    }

    private let error: Error

    public init(error: Error = FailError.undefined) {
        self.error = error
    }

    public func execute<Q: SqsQuery>(_: Q) -> Promise<Q.TResponse> {
        return Promise(self.error)
    }
}
