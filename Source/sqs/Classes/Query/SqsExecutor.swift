//
// Created by chchrn on 6/10/20.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation
import Promises

public protocol SqsExecutor {
    func execute<Q: SqsQuery>(_ query: Q) -> Promise<Q.TResponse>
}
