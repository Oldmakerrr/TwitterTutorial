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
        var values: [String: Any] = ["timestamp": Int(NSDate().timeIntervalSince1970),
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

    func fetchNotifications(completions: @escaping ([Notification]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var notifications = [Notification]()
        REF_NOTIFICATIONS.child(uid).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject],
                  let uid = dictionary["uid"] as? String else { return }
            UserService.shared.fetchUser(uid: uid) { user in
                guard let notification = Notification(user: user, dictionary: dictionary) else { return }
                notifications.append(notification)
                completions(notifications)
            }
        }

    }
}
