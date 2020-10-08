//
// Created by chchrn on 6/9/20.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation
import Promises
import wlog

@objc
public class WsWebServiceLog: NSObject, WsWebService {
    private let log: Log
    private let origin: WsWebService

    public init(_ origin: WsWebService,
                log: Log) {
        self.origin = origin
        self.log = log
    }

    public func send(request: WsRequestI,
                     priority: Float,
                     progressBlock: ProgressBlock?) -> Promises.Promise<WsWebResponse> {
        self.log.info("start_web_request",
                      parameters: [
                          "req": request.urlRequest().sqs_detailedDescription(),
                          "priority": "\(priority)",
                      ])

        let start = CFAbsoluteTimeGetCurrent()
        return self.origin.send(request: request,
                                priority: priority,
                                progressBlock: progressBlock).then { (response: WsWebResponse) -> WsWebResponse in
            self.log.info("success_web_request",
                          parameters: [
                              "req": request.urlRequest(),
                              "priority": "\(priority)",
                              "msec": Int((CFAbsoluteTimeGetCurrent() - start) * 1000),
                              "data.size_kb": Int(response.data.count / 1024),
                          ])
            return response
        }.catch { _ in
            self.log.error("fail_web_request",
                           parameters: ["req": request.urlRequest()])
        }
    }
}
