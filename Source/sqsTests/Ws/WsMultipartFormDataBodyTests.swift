//
// Created by chchrn on 17.10.2020.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation


@testable import Sqs
import XCTest

class WsMultipartFormDataBodyTests: XCTestCase {

    func testBoundary() {
        let encoding: String.Encoding = .utf8
        let field1Data = "value1".data(using: encoding) ?? Data()
        let field2Data = Data([0xda, 0xff])
        let boundary = "BoundaryBB";

        let part1 = WsMultipartFormDataPartEasy(name: "field1", data: field1Data)
        let part2 = WsMultipartFormDataPartEasy(name: "field2", data: field2Data)

        let body = try? WsMultipartFormDataBody(parts: [part1, part2], boundary: boundary).body()
        let expectedBody =
                (("--\(boundary)\r\n"
                        + "Content-Disposition: form-data;name=\"field1\"\r\n\r\n").data(using: encoding) ?? Data())
                        + field1Data
                        + (("\r\n--\(boundary)\r\n"
                        + "Content-Disposition: form-data;name=\"field2\"\r\n\r\n").data(using: encoding) ?? Data())
                        + field2Data
                        + (("\r\n--\(boundary)--\r\n").data(using: encoding) ?? Data())
        XCTAssertEqual(body, expectedBody)
    }

    func testCustomHeadersInBodyPart() {
        let encoding: String.Encoding = .utf8
        let field1Data = "value1".data(using: encoding) ?? Data()
        let field2Data = Data([0xda, 0xff])
        let boundary = "BoundaryBB";

        let part1 = WsMultipartFormDataPartEasy(name: "field1",
                                                additionalHeaders: [
                                                    "Content-type": "text/plain;charset=UTF-8"
                                                ],
                                                data: field1Data)
        let part2 = WsMultipartFormDataPartEasy(name: "field2",
                                                data: field2Data)

        let body = try? WsMultipartFormDataBody(parts: [part1, part2], boundary: boundary).body()
        let expectedBody =
                (("--\(boundary)\r\n"
                        + "Content-Disposition: form-data;name=\"field1\"\r\n\r\n"
                        + "Content-type: text/plain;charset=UTF-8\r\n"
                        + "\r\n"
                ).data(using: encoding) ?? Data())
                        + field1Data
                        + (("\r\n--\(boundary)\r\n"
                        + "Content-Disposition: form-data;name=\"field2\"\r\n\r\n").data(using: encoding) ?? Data())
                        + field2Data
                        + (("\r\n--\(boundary)--\r\n").data(using: encoding) ?? Data())
        XCTAssertEqual(body, expectedBody)
    }

}
