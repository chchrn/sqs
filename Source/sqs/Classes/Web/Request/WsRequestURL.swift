//
// Created by chchrn on 6/9/20.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation

@objc public class WsRequestURL: NSObject, WsRequestI {
    private let baseUrl: URL
    private let path: String

    @objc init(baseUrl: URL, path: String = "") {
        self.baseUrl = baseUrl
        self.path = path
    }

    public func urlRequest() -> URLRequest {
        var url = self.baseUrl
        if path.isEmpty == false {
            url = url.appendingPathComponent(path)
        }
        return URLRequest(url: url)
    }
}
