//
// Created by chchrn on 6/10/20.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation
import Promises
import wlog

public class SqsWebExecutor: SqsExecutor {
    private let origin: SqsExecutor
    private let webService: WsWebService
    private let parseQueue: DispatchQueue

    public init(origin: SqsExecutor,
                webService: WsWebService,
                parseQueue: DispatchQueue = DispatchQueue(label: "com.sqs.parsing",
                                                          attributes: .concurrent)) {
        self.origin = origin
        self.webService = webService
        self.parseQueue = parseQueue
    }

    public func execute<Q: SqsQuery>(_ query: Q) -> Promise<Q.TResponse> {
        if let webQuery = query as? SqsWebQuery,
            let req = webQuery.request() {
            var progressBlock: WsWebService.ProgressBlock?
            if let progressQuery = webQuery as? SqsWebQueryWithProgress {
                progressBlock = progressQuery.progressHandler()
            }

            let promise = self.webService.send(request: req,
                                               priority: webQuery.priority().rawValue,
                                               progressBlock: progressBlock).then(on: self.parseQueue) { (response: WsWebResponse) -> Promise<Q.TResponse> in
                do {
                    let queryResult = try webQuery.parse(response: response) as! Q.TResponse
                    return Promise(queryResult)
                } catch {
                    return Promise(error)
                }
            }
            return promise
        } else {
            return self.origin.execute(query)
        }
    }
}
