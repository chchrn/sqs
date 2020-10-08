//
// Created by chchrn on 6/10/20.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation

public enum SqsWebQueryPriority: Float {
    case low = 0.2
    case normal = 0.5
    case high = 1
}

public class SqsWebQueryResponse<T> {
    let response: T
    let data: Data

    init(response: T, data: Data) {
        self.response = response
        self.data = data
    }
}

public protocol SqsWebQuery {
    func request() -> WsRequestI?
    func priority() -> SqsWebQueryPriority

    // TODO: need return concrete class,
    // but cant do it without creating abstract class
    // for webQuery instead of this protocol
    func parse(response: WsWebResponse) throws -> Any
}

public protocol SqsWebQueryWithProgress: SqsWebQuery {
    func progressHandler() -> WsWebService.ProgressBlock?
}
