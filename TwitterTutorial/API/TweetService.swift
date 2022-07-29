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
    
    func uploadTweet(caption: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values: [String: Any] = ["uid": uid,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes": 0 ,
                      "retweets": 0,
                      "caption": caption]
        REF_TWEETS.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
    }
    
    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        REF_TWEETS.observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let tweetId = snapshot.key
            do {
                let tweet = try Tweet(tweetId: tweetId, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            } catch let error as NSError {
                print("DEBUG: Failed create Tweet with error: \(error.localizedDescription)")
            }
            
        }
    }
}
