//
// Created by chchrn on 16.10.2020.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation

@objc
class WsRequestMultipartFormData: WsRequestWrap {

    public required init(_ origin: WsRequestI,
                         bodyParts: [WsMultipartFormDataPart]) {
        let boundary = String(format: "Boundary+%08X%08X", arc4random(), arc4random())
        let headers = [
            "Content-Type": String(format:"multipart/form-data;boundary=\"%@\"", boundary)
        ]

        super.init(
                WsRequestHeader(
                        WsRequestBody(
                                origin,
                                body: WsMultipartFormDataBody(parts: bodyParts,
                                                              boundary: boundary)
                        ),
                        headers: headers
                )
        )
    }

    override func urlRequest() -> URLRequest {
        var req = super.urlRequest()
        var headers = req.allHTTPHeaderFields ?? [String: String]()
        headers["Content-Length"] = String(format:"%i", req.httpBody?.count ?? 0)
        req.allHTTPHeaderFields = headers
        return req
    }
}
