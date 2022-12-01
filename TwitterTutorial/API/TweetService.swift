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
                     completion: @escaping(DatabaseCompletion)
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
                .updateChildValues(values) { error, reference in
                    guard let replyId = reference.key else { return }
                    REF_USER_REPLIES.child(uid)
                        .updateChildValues([tweet.tweetId: replyId], withCompletionBlock: completion)
                }
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
            self.fetchTweet(withTweetID: tweetId) { tweet in
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }

    func fetchTweet(withTweetID tweetId: String, completion: @escaping(Tweet) -> Void) {
        REF_TWEETS.child(tweetId).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any],
                  let uid = dictionary["uid"] as? String else { return }
            UserService.shared.fetchUser(uid: uid) { user in
                let tweetId = snapshot.key
                do {
                    let tweet = try Tweet(user: user, tweetId: tweetId, dictionary: dictionary)
                    completion(tweet)
                } catch let error as NSError {
                    print("DEBUG: Failed create Tweet with error: \(error.localizedDescription)")
                }
            }
        }
    }

    func fetchLikedTweets(forUser user: User, completion: @escaping ([Tweet]) -> Void) {
        var tweets = [Tweet]()
        REF_USER_LIKES.child(user.uid).observe(.childAdded) { snapshot in
            self.fetchTweet(withTweetID: snapshot.key) { tweet in
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }

    func fetchReplies(forTweet tweet: Tweet, completion: @escaping ([Tweet]) -> Void) {
        var tweets = [Tweet]()
        REF_TWEETS_REPLIES.child(tweet.tweetId).observeSingleEvent(of: .childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject],
                  let uid = dictionary["uid"] as? String else { return }
            let tweetUid = snapshot.key
            UserService.shared.fetchUser(uid: uid) { user in
                do {
                    let tweet = try Tweet(user: user, tweetId: tweetUid, dictionary: dictionary)
                    tweets.append(tweet)
                    completion(tweets)
                } catch let error as NSError {
                    print("DEBUG: Failed create Tweet with error: \(error.localizedDescription)")
                }
            }
        }
    }

    func fetchRelies(forUser user: User, completion: @escaping ([Tweet]) -> Void) {
        var replies = [Tweet]()
        REF_USER_REPLIES.child(user.uid).observe(.childAdded) { snapshot in
            let tweetKey = snapshot.key
            guard let replyKey = snapshot.value as? String else { return }
            REF_TWEETS_REPLIES.child(tweetKey).child(replyKey).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String: Any],
                      let uid = dictionary["uid"] as? String else { return }
                UserService.shared.fetchUser(uid: uid) { user in
                    do {
                        let reply = try Tweet(user: user, tweetId: tweetKey, dictionary: dictionary)
                        replies.append(reply)
                        completion(replies)
                    } catch let error as NSError {
                        print("DEBUG: Failed create Tweet with error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    func likeTweet(tweet: Tweet, completion: @escaping(DatabaseCompletion)) {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
        REF_TWEETS.child(tweet.tweetId).child("likes").setValue(likes)
        if tweet.didLike {
            //unlike tweet
            //remove user which has likes tweet
            REF_USER_LIKES.child(userUid).child(tweet.tweetId).removeValue { error, reference in
                //remove tweet which likes users
                REF_TWEET_LIKES.child(tweet.tweetId).child(userUid).removeValue(completionBlock: completion)
            }
        } else {
            //like tweet
            //set user which has likes tweet
            REF_USER_LIKES.child(userUid).updateChildValues([tweet.tweetId: 1]) { error, reference in
                //set tweet which likes users
                REF_TWEET_LIKES.child(tweet.tweetId).updateChildValues([userUid: 1], withCompletionBlock: completion)
            }
        }
    }

    func checkIfUserLikedTweet(_ tweet: Tweet, completion: @escaping (Bool) -> Void) {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        REF_USER_LIKES.child(userUid).child(tweet.tweetId).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
}
