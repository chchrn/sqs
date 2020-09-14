//
// Created by chchrn on 6/9/20.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation

@objc
public class WsRequestHeader: NSObject, WsRequestI {
    private let origin: WsRequestI
    private let headers: [String: String]

    @objc
    public init(_ origin: WsRequestI,
                headers: [String: String]) {
        self.origin = origin
        self.headers = headers
    }

    public func urlRequest() -> URLRequest {
        var request = self.origin.urlRequest()
        self.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }
}
