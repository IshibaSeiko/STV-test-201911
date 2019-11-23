//
//  NetWork.swift
//  STVTest201911
//
//  Created by STV-M025 on 2019/11/23.
//  Copyright © 2019 STV-M025. All rights reserved.
//

import Reachability

final class Network {
    
    static func isOnline() -> Bool {
        guard let reachability = Reachability() else { return false }
        return reachability.connection != .none
    }
    
}
