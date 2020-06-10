//
// Created by chchrn on 6/9/20.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation

@objc public class WsRequestJsonBody: WsRequestWrap {
    @objc public init(_ origin: WsRequestI,
               parameters: [String: Any]) {
        super.init(
                WsRequestHeader(
                        WsRequestBody(
                                origin,
                                body: WsJsonBody(params: parameters)),
                        headers: ["Content-Type": "application/json"]))
    }
}
