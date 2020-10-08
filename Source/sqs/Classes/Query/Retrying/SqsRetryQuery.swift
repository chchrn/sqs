//
// Created by chchrn on 6/10/20.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation

public protocol SqsRetryQuery {
    func retryCount() -> UInt
}
