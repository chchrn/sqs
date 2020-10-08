//
// Created by chchrn on 6/9/20.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation
import Promises

public protocol WsWebService {
    typealias ProgressBlock = (_ progress: Float,
                               _ totalBytesExpected: Int) -> Void

    func send(request: WsRequestI,
              priority: Float,
              progressBlock: ProgressBlock?) -> Promise<WsWebResponse>
}
