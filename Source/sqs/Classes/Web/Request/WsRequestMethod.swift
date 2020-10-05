//
// Created by chchrn on 6/9/20.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation

@objc
public class WsRequestMethod: NSObject, WsRequestI {
    private let origin: WsRequestI
    private let method: String

    @objc
    public init(_ origin: WsRequestI, method: String) {
        self.origin = origin
        self.method = method
    }

    // MARK: WsRequestI

    @objc
    public func urlRequest() -> URLRequest {
        var request = self.origin.urlRequest()
        request.httpMethod = self.method
        return request
    }
}
