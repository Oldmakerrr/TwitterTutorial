//
//  TweetService.swift
//  TwitterTutorial
//
//  Created by Apple on 29.07.2022.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

struct TweetService {
    
    static let shared = TweetService()
    
    func uploadTweet(caption: String,
                     type: UploadTweetConfiguration,
                     completion: @escaping(Error?, DatabaseReference) -> Void
    ) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values: [String: Any] = ["uid": uid,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes": 0 ,
                      "retweets": 0,
                      "caption": caption]

        switch type {
        case .tweet:
            REF_TWEETS.childByAutoId().updateChildValues(values) { error, reference in
                guard let tweetId = reference.key else { return }
                REF_USER_TWEETS.child(uid).updateChildValues([tweetId : 1], withCompletionBlock: completion)
            }
        case .reply(let tweet):
            REF_TWEETS_REPLIES.child(tweet.tweetId).childByAutoId()
                .updateChildValues(values, withCompletionBlock: completion)
        }
    }
    
    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        REF_TWEETS.observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any],
                  let uid = dictionary["uid"] as? String else { return }
            UserService.shared.fetchUser(uid: uid) { user in
                let tweetId = snapshot.key
                do {
                    let tweet = try Tweet(user: user, tweetId: tweetId, dictionary: dictionary)
                    tweets.append(tweet)
                    completion(tweets)
                } catch let error as NSError {
                    print("DEBUG: Failed create Tweet with error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchTweets(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        REF_USER_TWEETS.child(user.uid).observe(.childAdded) { snapshot in
            let tweetId = snapshot.key
            REF_TWEETS.child(tweetId).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String: Any],
                      let uid = dictionary["uid"] as? String else { return }
                UserService.shared.fetchUser(uid: uid) { user in
                    let tweetId = snapshot.key
                    do {
                        let tweet = try Tweet(user: user, tweetId: tweetId, dictionary: dictionary)
                        tweets.append(tweet)
                        completion(tweets)
                    } catch let error as NSError {
                        print("DEBUG: Failed create Tweet with error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

}
