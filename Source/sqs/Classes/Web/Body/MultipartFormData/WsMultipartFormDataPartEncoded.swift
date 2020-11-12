//
// Created by chchrn on 16.10.2020.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation

internal class WsMultipartFormDataPartEncoded {
    private let part: WsMultipartFormDataPart
    private let encoding: String.Encoding

    init(part: WsMultipartFormDataPart,
         encoding: String.Encoding) {
        self.part = part
        self.encoding = encoding
    }

    func data() -> Data {
        var data = Data()
        data.append(self.headerData())
        data.append(self.part.content)
        return data
    }

    private func headerData() -> Data {
        let keys = self.part.headers.keys.sorted(by: <)
        var string = keys.map { key -> String in
            let value = self.part.headers[key]!
            return String(format: "%@: %@\r\n", key, value)
        }.joined(separator: "\r\n")
        string += "\r\n"
        return string.data(using: self.encoding) ?? Data()
    }
}
