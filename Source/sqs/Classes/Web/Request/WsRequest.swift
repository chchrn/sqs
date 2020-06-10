//
// Created by chchrn on 6/9/20.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation

@objc public class WsRequest: WsRequestWrap {
    typealias QueryParams = [String: Any]

    @objc public init(baseUrl: URL,
                      path: String = "",
                      queryParams: QueryParams = QueryParams()) {
        super.init(
                WsRequestQueryParams(
                        WsRequestURL(baseUrl: baseUrl,
                                     path: path),
                        queryParams: queryParams)
        )
    }
}
