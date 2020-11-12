//
// Created by chchrn on 15.10.2020.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation

public class WsMultipartFormDataBody: WsBody {
    private let parts: [WsMultipartFormDataPart]
    private let boundary: String
    private let encoding: String.Encoding

    public required init(parts: [WsMultipartFormDataPart],
                         boundary: String,
                         encoding: String.Encoding = .utf8) {
        self.parts = parts
        self.boundary = boundary
        self.encoding = encoding
    }

    public func body() throws -> Data {
        var data = Data()
        data.append(WsBoundaryData(WsInitialBoundary(self.boundary), self.encoding).data)

        let encodedParts = self.parts.map { part -> WsMultipartFormDataPartEncoded in
            return WsMultipartFormDataPartEncoded(part: part, encoding: self.encoding)
        }
        encodedParts.enumerated().forEach { (i: Int, encodedPart: WsMultipartFormDataPartEncoded) in
            if i > 0 {
                data.append(WsBoundaryData(WsEncapsulationBoundary(self.boundary), self.encoding).data)
            }
            data.append(encodedPart.data())
        }
        data.append(WsBoundaryData(WsFinalBoundary(self.boundary), self.encoding).data)

        return data
    }

    public func bodyLength() -> UInt64 {
        return self.parts.reduce(into: UInt64(0)) { result, part in
            result + part.contentLength
        }
    }
}
