//
// Created by chchrn on 15.10.2020.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation

protocol WsBoundary {
    var string: String {get}
}

internal class WsBoundaryEasy: WsBoundary {
    internal let boundary: String
    required init(_ boundary: String) {
        self.boundary = boundary;
    }

    var string: String {
        fatalError("Not implemented")
    }
}

internal class WsInitialBoundary: WsBoundaryEasy {
    override var string: String {
        return String(format: "--%@\r\n", self.boundary)
    }
}

internal class WsEncapsulationBoundary: WsBoundaryEasy {
    override var string: String {
        return String(format: "\r\n--%@\r\n", self.boundary)
    }
}

internal class WsFinalBoundary: WsBoundaryEasy {
    override var string: String {
        return String(format: "\r\n--%@--\r\n", self.boundary)
    }
}

internal class WsBoundaryData {
    private let boundary: WsBoundary
    private let encoding: String.Encoding

    convenience init(_ boundary: WsBoundary,
                     _ encoding: String.Encoding) {
        self.init(boundary: boundary, encoding: encoding)
    }

    required init(boundary: WsBoundary,
                  encoding: String.Encoding) {
        self.boundary = boundary
        self.encoding = encoding
    }

    var data: Data {
        return self.boundary.string.data(using: self.encoding) ?? Data()
    }
}

