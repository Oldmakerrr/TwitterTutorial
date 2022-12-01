//
//  Notification.swift
//  TwitterTutorial
//
//  Created by Vladimir Berezin on 01.12.22.
//

import Foundation

enum NotificationType: Int {
    case follow
    case like
    case reply
    case retweet
    case mention
}

struct Notification {
    let tweetId: String?
    let timestamp: Date
    var user: User
    let tweet: Tweet?
    let type: NotificationType

    init?(user: User, tweet: Tweet? = nil, dictionary: [String: AnyObject]) {
        self.user = user
        self.tweet = tweet
        self.tweetId = dictionary["tweetId"] as? String
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        } else {
            return nil
        }
        if let rawValue = dictionary["type"] as? Int,
           let type = NotificationType(rawValue: rawValue) {
            self.type = type
        } else {
            return nil
        }
    }
}
