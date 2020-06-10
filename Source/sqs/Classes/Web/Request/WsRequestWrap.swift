//
// Created by chchrn on 6/9/20.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation

@objc public class WsRequestWrap: NSObject, WsRequestI {
    private let origin: WsRequestI

    @objc init(_ origin: WsRequestI) {
        self.origin = origin
    }

    // MARK: WsRequestI
    @objc public func urlRequest() -> URLRequest {
        self.origin.urlRequest()
    }
}
