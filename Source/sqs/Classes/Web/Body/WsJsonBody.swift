//
// Created by chchrn on 6/9/20.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation

public class WsJsonBody: WsBody {
    private let params: Any

    init(params: [String: Any]) {
        self.params = params
    }

    init(array: [[String: Any]]) {
        self.params = array
    }

    public func body() throws -> Data {
        let data = try JSONSerialization.data(withJSONObject: self.params)
        return data
    }
}
