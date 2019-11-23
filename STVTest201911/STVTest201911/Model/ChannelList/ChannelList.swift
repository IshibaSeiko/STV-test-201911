//
//  ChannelList.swift
//  STVTest201911
//
//  Created by STV-M025 on 2019/11/23.
//  Copyright © 2019 STV-M025. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

struct ChannelList: Codable {
    let channels: [Channels]
}

struct Channels: Codable {
    let name: String
    let duration: String
    let number: Int
    let imageUrl: String
    let link: String
}

class ChannelListData: Object {
    @objc dynamic var id: String = NSUUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var duration: String = ""
    @objc dynamic var number: Int = 0
    @objc dynamic var imageUrl: String = ""
    @objc dynamic var link: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

func setChannelListDataFromAPI(data: ChannelList) -> [ChannelListData] {
    
    var setData: [ChannelListData] = []
    
    for object in data.channels {
        let setObject = ChannelListData()
        setObject.name = object.name
        setObject.duration = object.duration
        setObject.number = object.number
        setObject.imageUrl = object.imageUrl
        setObject.link = object.link
        setData.append(setObject)
    }
    
    return setData
}
