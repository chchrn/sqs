//
// Created by chchrn on 6/9/20.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation
import Promises

@objc
public class WsWebServiceOnUrlSession: NSObject, WsWebService {
    private let urlSession: URLSession
    private let queue: OperationQueue

    @objc public convenience init(urlSession: URLSession,
                                  maxConcurrentOperationCount: Int = 20) {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = maxConcurrentOperationCount
        self.init(urlSession: urlSession, queue: queue)
    }

    public required init(urlSession: URLSession,
                         queue: OperationQueue) {
        self.urlSession = urlSession
        self.queue = queue
    }

    // WsWebService
    public func send(request: WsRequestI,
                     priority: Float,
                     progressBlock: ProgressBlock?) -> Promise<WsWebResponse> {
        let promise = Promise<WsWebResponse>.pending()
        let operation = WsWebServiceOperation(urlSession: self.urlSession,
                                              request: request,
                                              priority: priority,
                                              promise: promise,
                                              progressBlock: progressBlock)
        self.queue.addOperation(operation)
        return promise
    }
}
