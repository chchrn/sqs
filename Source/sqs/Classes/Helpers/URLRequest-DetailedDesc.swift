//
// Created by chchrn on 6/11/20.
// Copyright (c) 2020 chchrn. All rights reserved.
//

import Foundation

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

        if self.httpBody != nil,
           let json = try? JSONSerialization.jsonObject(with: self.httpBody!) {
            desc += "\nBODY: \(json)"
        }

        return desc
    }
}