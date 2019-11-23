//
//  Dictionary+JSON.swift
//  STVTest201911
//
//  Created by STV-M025 on 2019/11/23.
//  Copyright © 2019 STV-M025. All rights reserved.
//

import Foundation

extension Dictionary {
    
    var prettyPrintedJsonString: String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
            return String(bytes: jsonData, encoding: .utf8) ?? "JSON Covert Failre."
        } catch {
            return "JSON Covert Failre."
        }
    }
}
