//
// Created by chchrn on 6/9/20.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation

@objc public protocol WsBody {
    func body() throws -> Data
}
