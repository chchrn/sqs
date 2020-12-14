//
// Created by chchrn on 6/9/20.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation

@objc
public protocol WsBody {
    func body() throws -> Data
    func bodyLength() -> UInt64
}

extension WsBody {
    public func bodyLength() -> UInt64 {
        return 0
    }
}
