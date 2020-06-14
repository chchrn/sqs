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
    private let queue: DispatchQueue
    private let log: Log

    public init(origin: SqsExecutor,
                webService: WsWebService,
                queue: DispatchQueue = DispatchQueue(label: "com.sqs.parsing",
                                                     attributes: .concurrent),
                log: Log = NullLog()) {
        self.origin = origin
        self.webService = webService
        self.queue = queue
        self.log = log
    }

    public func execute<Q: SqsQuery>(_ query: Q) -> Promise<Q.TResponse> {
        if let webQuery = query as? SqsWebQuery,
           let req = webQuery.request() {
            var progressBlock: WsWebService.ProgressBlock?
            if let progressQuery = webQuery as? SqsWebQueryWithProgress {
                progressBlock = progressQuery.progressHandler()
            }

            self.log.info("Starting query", parameters: ["query": query])
            let promise = self.webService.send(request: req,
                                               priority: webQuery.priority().rawValue,
                                               progressBlock: progressBlock).then(on: self.queue) { (response: WsWebResponse) -> Promise<Q.TResponse> in
                do {
                    let queryResult = try webQuery.parse(response: response) as! Q.TResponse
                    return Promise(queryResult)
                } catch {
                    return Promise(error)
                }
            }.catch { error in
                self.log.error("Fail query",
                               parameters: ["query": query,
                                            "error": error.localizedDescription])
            }
            return promise
        } else {
            return self.origin.execute(query)
        }
    }
}
