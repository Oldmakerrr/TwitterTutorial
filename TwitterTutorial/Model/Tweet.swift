//
//  Tweet.swift
//  TwitterTutorial
//
//  Created by Apple on 29.07.2022.
//

import Foundation

struct Tweet {
    let caption: String
    let tweetId: String
    let uid: String
    var likes: Int
    let timestamp: Date
    let retweetsCount: Int
    var user: User
    var didLike = false
    
    init(user: User, tweetId: String, dictionary: [String: Any]) throws {
        self.user = user
        self.tweetId = tweetId
        if let caption = dictionary["caption"] as? String {
            self.caption = caption
        } else {
            throw NSError(domain: "Failed to parse Caption", code: 201)
        }
        if let uid = dictionary["uid"] as? String {
            self.uid = uid
        } else {
            throw NSError(domain: "Failed to parse Uid", code: 202)
        }
        if let likes = dictionary["likes"] as? Int {
            self.likes = likes
        } else {
            throw NSError(domain: "Failed to parse Likes", code: 203)
        }
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        } else {
            throw NSError(domain: "Failed to parse Time Stamp", code: 204)
        }
        if let retweetsCount = dictionary["retweets"] as? Int {
            self.retweetsCount = retweetsCount
        } else {
            throw NSError(domain: "Failed to parse Retweets Count", code: 205)
        }
        
    }
    
}
