//
//  NotificationViewModel.swift
//  TwitterTutorial
//
//  Created by Vladimir Berezin on 01.12.22.
//

import UIKit

struct NotificationViewModel {

    private let notification: Notification
    private let type: NotificationType
    private let user: User

    private var timestamp: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: notification.timestamp, to: now)
    }

    private var notificationMessage: String {
        switch type {
        case .follow: return " started following you"
        case .like: return " liked your tweets"
        case .reply: return " replied to your tweet"
        case .retweet: return " retweeded your tweet"
        case .mention: return " mentioned you in tweet"
        }
    }

    var profileImageUrl: URL {
        user.profileImageUrl
    }

    var shouldHideFollowButton: Bool {
        return type != .follow
    }

    var followButtonTitle: String {
        user.isFollowed ? "Following" : "Follow"
    }

    var notificationText: NSAttributedString? {
        guard let timestamp = timestamp else { return nil }
        let attributedText = NSMutableAttributedString(string: user.username,
                                                       attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)])
        attributedText.append(NSAttributedString(string: notificationMessage,
                                                 attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]))
        attributedText.append(NSAttributedString(string: " \(timestamp)",
                                                 attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
                                                              NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        return attributedText
    }

    init(notification: Notification) {
        self.notification = notification
        self.type = notification.type
        self.user = notification.user
    }
}
