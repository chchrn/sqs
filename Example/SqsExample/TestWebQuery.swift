//
// Created by chchrn on 6/11/20.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation
import Sqs

class TestWebQuery: SqsQuery {
    typealias TResponse = [String]
}

extension TestWebQuery: SqsWebQuery {
    func request() -> WsRequestI? {
        let r =
            WsRequestMethod(
                WsRequestJsonBody(
                    WsRequest(baseUrl: URL(string: "https://google.com")!,
                              path: "/apiTest"),
                    parameters: [
                        "var1": "value1",
                        "var2": "value2",
                    ]
                ),
                method: "POST"
            )
        return r
    }

    func priority() -> SqsWebQueryPriority {
        return .high
    }

    func parse(response _: WsWebResponse) throws -> Any {
        return ["success"]
    }
}
