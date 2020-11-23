//
// Created by chchrn on 23.11.2020.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation

public class WsRequestTimeout: WsRequestI {
    private let origin: WsRequestI
    private let timeout: TimeInterval

    public init(_ origin: WsRequestI,
                timeout: TimeInterval) {
        self.origin = origin
        self.timeout = timeout
    }

    @objc
    public func urlRequest() -> URLRequest {
        var request = self.origin.urlRequest()
        request.timeoutInterval = self.timeout
        return request
    }
}
