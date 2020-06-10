//
// Created by chchrn on 6/9/20.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation

public class WsRequestQueryParams: WsRequestI {
    private let origin: WsRequestI
    private let queryParams: [String: Any]
    public init(_ origin: WsRequestI,
                queryParams: [String: Any]) {
        self.origin = origin
        self.queryParams = queryParams
    }

    public func urlRequest() -> URLRequest {
        var urlRequest = self.origin.urlRequest()
        if let url = urlRequest.url {
            var urlStr = url.absoluteString
            let queryParamsStr = self.queryString()
            if urlStr.contains("?") {
                urlStr += "&" + queryParamsStr
            } else {
                urlStr += "?" + queryParamsStr
            }

            urlRequest.url = URL(string: urlStr)
        }
        return urlRequest
    }

    private func queryString() -> String {
        let percentEncode: (String) -> String = { str in
            let encoded = str.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            assert(encoded != nil)
            return encoded!
        }
        var components = self.queryParams.map { (key: String, value: Any) -> String in
            if let descValue = value as? CustomStringConvertible {
                return String(format: "%@=%@", percentEncode(key), percentEncode(descValue.description))
            }
            return ""
        }
        components = components.filter { (string: String) -> Bool in
            return string.count > 0
        }

        return components.joined(separator: "&")
    }
}
