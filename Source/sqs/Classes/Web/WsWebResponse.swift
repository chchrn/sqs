//
// Created by chchrn on 6/9/20.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation

@objc public class WsWebResponse: NSObject {
    let data: Data
    let urlResponse: URLResponse

    init(data: Data, urlResponse: URLResponse) {
        self.data = data
        self.urlResponse = urlResponse
    }
}
