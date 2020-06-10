//
// Created by chchrn on 6/10/20.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation
import Promises

public class SqsRetryExecutor: SqsExecutor {
    private let origin: SqsExecutor

    public init(_ origin: SqsExecutor) {
        self.origin = origin
    }

    public func execute<Q: SqsQuery>(_ query: Q) -> Promise<Q.TResponse> {
        if let retryQuery = query as? SqsRetryQuery {
            let pendingPromise = Promise<Q.TResponse>.pending()
            self.execute(query,
                         retryCount: retryQuery.retryCount(),
                         pendingPromise: pendingPromise)
            return pendingPromise
        } else {
            return self.origin.execute(query)
        }
    }

    private func execute<T, Q: SqsQuery>(_ query: Q,
                                         retryCount: UInt,
                                         pendingPromise: Promise<T>) where T == Q.TResponse {
        self.origin.execute(query).then { (response: Q.TResponse) in
            pendingPromise.fulfill(response)
        }.catch { error in
            if retryCount > 0 {
                self.execute(query,
                             retryCount: (retryCount-1),
                             pendingPromise: pendingPromise)
            } else {
                pendingPromise.reject(error)
            }
        }
    }
}
