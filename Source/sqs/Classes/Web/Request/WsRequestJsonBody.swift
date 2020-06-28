//
// Created by chchrn on 6/9/20.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation

@objc public class WsRequestJsonBody: WsRequestWrap {
    @objc public convenience init(_ origin: WsRequestI,
                                  parameters: [String: Any]) {
        self.init(origin, body: WsJsonBody(params: parameters))
    }

    @objc public convenience init(_ origin: WsRequestI,
                                  array: [Any]) {
        self.init(origin, body: WsJsonBody(array: array))
    }

    public required init(_ origin: WsRequestI,
                         body: WsJsonBody) {
        super.init(
                WsRequestHeader(
                        WsRequestBody(
                                origin,
                                body: body),
                        headers: ["Content-Type": "application/json"]
                )
        )
    }



}
