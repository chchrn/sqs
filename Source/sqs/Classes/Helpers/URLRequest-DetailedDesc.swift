//
// Created by chchrn on 6/11/20.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation

extension Data {
    var sqs_prettyPrintedJSONString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding: String.Encoding.utf8) else { return nil }

        return prettyPrintedString
    }
}


extension URLRequest {
    func sqs_detailedDescription() -> String {
        var desc = String(describing: type(of: self))
                   + " "
                   + (self.httpMethod ?? "")
                   + " "
                   + String(describing: self)

        if self.allHTTPHeaderFields?.isEmpty == false {
            desc += "\nHEADERS: \(self.allHTTPHeaderFields!)"
        }

        if let httpBody = self.httpBody,
           let jsonStr = httpBody.sqs_prettyPrintedJSONString {
            desc += "\nBODY: \(jsonStr)"
        }

        return desc
    }
}