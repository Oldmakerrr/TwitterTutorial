//
//  UploadTweetViewModel.swift
//  TwitterTutorial
//
//  Created by Vladimir Berezin on 30.11.22.
//

import Foundation

enum UploadTweetConfiguration {
    case tweet
    case reply(Tweet)
}

struct UploadTweetViewModel {

    var actionButtonTitle: String {
        switch config {
        case .tweet:
            return "Tweet"
        case .reply(_):
            return "Reply"
        }
    }

    var placeHolderText: String {
        switch config {
        case .tweet:
            return "What's happening?"
        case .reply(_):
            return "Tweet your reply"
        }
    }

    var shouldShowReplyLabel: Bool {
        switch config {
        case .tweet:
            return false
        case .reply(_):
            return true
        }
    }

    var replyText: String? {
        switch config {
        case .tweet:
            return nil
        case .reply(let tweet):
            return "Replying to @\(tweet.user.username)"
        }
    }

    let config: UploadTweetConfiguration

    init(config: UploadTweetConfiguration) {
        self.config = config
    }
}
