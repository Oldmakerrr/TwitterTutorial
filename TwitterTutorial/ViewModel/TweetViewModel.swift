//
//  TweetViewModel.swift
//  TwitterTutorial
//
//  Created by Apple on 31.07.2022.
//

import Foundation
import UIKit

struct TweetViewModel {
    
    let tweet: Tweet
    let user: User
    
    var profileImageUrl: URL {
        return tweet.user.profileImageUrl
    }
    
    var timestamp: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: tweet.timestamp, to: now)
    }
    
    var userInfoText: NSAttributedString {
        let title = NSMutableAttributedString(string: user.fullname,
                                              attributes: [.font:UIFont.boldSystemFont(ofSize: 14)])
        let subStringAttribute: [NSAttributedString.Key:Any] = [.font:UIFont.systemFont(ofSize: 14),
                                                                .foregroundColor: UIColor.lightGray]
        let userName = NSAttributedString(string: " @\(user.username)",
                                          attributes: subStringAttribute)
        title.append(userName)
        guard let timestamp = timestamp else { return title }
        let timestampString = NSAttributedString(string: " ・ \(timestamp)",
                                          attributes: subStringAttribute)
        title.append(timestampString)
        return title
    }
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
}
