//
// Created by chchrn on 6/9/20.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation

public class WsDataBody: WsBody {
    private let data: Data
    init(data: Data) {
        self.data = data
    }

    // WsBody
    public func body() throws -> Data {
        return self.data
    }
}
