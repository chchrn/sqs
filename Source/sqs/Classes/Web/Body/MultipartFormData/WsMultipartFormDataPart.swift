//
// Created by chchrn on 16.10.2020.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation

public protocol WsMultipartFormDataPart {
    var headers: [String: String] {get}
    var content: Data {get}
    var contentLength: UInt64 {get}
}

public class WsMultipartFormDataPartEasy: WsMultipartFormDataPart {
    public let headers: [String: String]
    public let content: Data

    public convenience init(name: String,
                            filename: String = "",
                            additionalHeaders: [String: String] = [:],
                            value: String) {
        self.init(name: name,
                  filename: filename,
                  additionalHeaders: additionalHeaders,
                  data: value.data(using: .utf8) ?? Data())
    }

    public convenience init(name: String,
                            filename: String = "",
                            additionalHeaders: [String: String] = [:],
                            data: Data) {
        var dispositionArr = ["form-data"]
        if name.isEmpty == false {
            dispositionArr.append(String(format: "name=\"%@\"", name))
        }
        if filename.isEmpty == false {
            dispositionArr.append(String(format: "filename=\"%@\"", filename))
        }

        var headers = [String: String]()
        headers["Content-Disposition"] = dispositionArr.joined(separator: "; ")
        headers.merge(additionalHeaders) { (current, _) in current }

        self.init(headers: headers,
                  content: data)
    }

    public required init(headers: [String: String],
                         content: Data) {
        self.headers = headers
        self.content = content
    }

    public var contentLength: UInt64 {
        return UInt64(self.content.count)
    }
}