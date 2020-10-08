//
// Created by chchrn on 6/10/20.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation

public enum SqsError: Error {
    case invalidData
    case cantSendRequest
}

public protocol SqsQuery {
    associatedtype TResponse
}
