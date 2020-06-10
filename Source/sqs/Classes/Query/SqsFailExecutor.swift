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

    public init() {}

    public func execute<Q: SqsQuery>(_ query: Q) -> Promise<Q.TResponse> {
        return Promise(Self.FailError.undefined)
    }
}
