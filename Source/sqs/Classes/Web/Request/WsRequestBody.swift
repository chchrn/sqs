//
// Created by chchrn on 6/9/20.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation

@objc public class WsRequestBody: NSObject, WsRequestI {
    private let origin: WsRequestI
    private let body: WsBody

    public init(_ origin: WsRequestI,
         body: WsBody) {
        self.origin = origin
        self.body = body
    }

    // MARK: WsRequestI
    @objc public func urlRequest() -> URLRequest {
        var request = self.origin.urlRequest()
        do {
            let body = try self.body.body()
            request.httpBody = body
        } catch {
            print("Can't insert body for object \(self), request \(request)")
        }
        return request
    }
}
