//
//  VideoList.swift
//  STVTest201911
//
//  Created by STV-M025 on 2019/11/23.
//  Copyright © 2019 STV-M025. All rights reserved.
//

import UIKit

import Realm
import RealmSwift

struct MovieList: Codable {
    let user: user
    let videos: [video]
}

struct user: Codable {
    let id: Int
    let username: String
}

struct video: Codable {
    let id: Int
    let name: String
    let link: String
    let imageUrl: String
    let numberOfViews: Int
    let channel: Channel
}

struct Channel: Codable {
    let name: String
    let profileImageUrl: String
    let numberOfSubscribers: Int
}

class VideoListData: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var link: String = ""
    @objc dynamic var imageUrl: String = ""
    @objc dynamic var numberOfViews: Int = 0
    @objc dynamic var channelName: String = ""
    @objc dynamic var profileImageUrl: String = ""
    @objc dynamic var numberOfSubscribers: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

func setMovieListDataFromAPI(data: MovieList) -> [VideoListData] {
    var setData: [VideoListData] = []
    
    for video in data.videos {
        let videoData = VideoListData()
        videoData.id = video.id
        videoData.name = video.name
        videoData.link = video.link
        videoData.imageUrl = video.imageUrl
        videoData.numberOfViews = video.numberOfViews
        videoData.channelName = video.channel.name
        videoData.profileImageUrl = video.channel.profileImageUrl
        videoData.numberOfSubscribers = video.channel.numberOfSubscribers
        setData.append(videoData)
    }
    return setData
}

