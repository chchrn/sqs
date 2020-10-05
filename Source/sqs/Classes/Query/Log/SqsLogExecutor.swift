//
// Created by chchrn on 05.10.2020.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation
import Promises
import wlog

public class SqsLogExecutor: SqsExecutor {
    private let origin: SqsExecutor
    private let log: Log

    init(origin: SqsExecutor,
         log: Log) {
        self.origin = origin
        self.log = log
    }

    public func execute<Q: SqsQuery>(_ query: Q) -> Promises.Promise<Q.TResponse> {
        let queryDesc = String(describing: query)
        self.log.debug("start_query", parameters: ["query": queryDesc])
        return self.origin.execute(query).then { (response: Q.TResponse) -> Q.TResponse in
            self.log.debug("success_query", parameters: ["query": queryDesc])
            return response
        }.catch { _ in
            self.log.error("fail_query", parameters: ["query": queryDesc])
        }
    }
}
