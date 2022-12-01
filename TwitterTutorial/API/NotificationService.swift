//
//  NotificationService.swift
//  TwitterTutorial
//
//  Created by Vladimir Berezin on 01.12.22.
//

import Foundation
import FirebaseAuth

struct NotificationService {

    static let shared = NotificationService()

    func uploadNotification(type: NotificationType,
                            tweet: Tweet? = nil,
                            user: User? = nil
    ) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var values: [String: Any] = ["timestamp": Int(Date.timeIntervalBetween1970AndReferenceDate),
                                     "uid": uid,
                                     "type": type.rawValue]
        var childUid = uid
        if let tweet = tweet {
            values["tweetId"] = tweet.tweetId
            childUid = tweet.user.uid
        }
        if let user = user {
            childUid = user.uid
        }
        REF_NOTIFICATIONS.child(childUid).childByAutoId().updateChildValues(values)
    }

}
