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

    func uploadNotification(toUser user: User,
                            type: NotificationType,
                            tweetId: String? = nil
       ) {
           guard let uid = Auth.auth().currentUser?.uid else { return }
           var values: [String: Any] = ["timestamp": Int(NSDate().timeIntervalSince1970),
                                        "uid": uid,
                                        "type": type.rawValue]
           if let tweetId = tweetId {
               values["tweetId"] = tweetId
           }
        REF_NOTIFICATIONS.child(user.uid).childByAutoId().updateChildValues(values)
    }

    func fetchNotifications(completions: @escaping ([Notification]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var notifications = [Notification]()

        REF_NOTIFICATIONS.child(uid).observeSingleEvent(of: .value) { snapshot in
            if !snapshot.exists() {
                completions(notifications)
            } else {
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
    }
}
