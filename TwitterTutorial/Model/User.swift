//
//  User.swift
//  TwitterTutorial
//
//  Created by Apple on 26.07.2022.
//

import Foundation
import FirebaseAuth

struct User {
    let fullname: String
    let email: String
    let username: String
    let profileImageUrl: URL
    let uid: String
    var isFollowed: Bool = false
    var stats: UserRelationStats?
    var bio: String?
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid }
    
    init(uid: String, dictionary: [String: AnyObject]) throws {
        self.uid = uid
        if let fullname = dictionary["fullname"] as? String {
            self.fullname = fullname
        } else {
            throw NSError(domain: "Failed to parse Fullname", code: 101)
        }
        if let email = dictionary["email"] as? String {
            self.email = email
        } else {
            throw NSError(domain: "Failed to parse Email", code: 102)
        }
        if let username = dictionary["username"] as? String {
            self.username = username
        } else {
            throw NSError(domain: "Failed to parse Username", code: 103)
        }
        if let bio = dictionary["bio"] as? String {
            self.bio = bio
        } 
        if let profileImage = dictionary["profileImageUrl"] as? String,
            let profileImageUrl = URL(string: profileImage)  {
            self.profileImageUrl = profileImageUrl
        } else {
            throw NSError(domain: "Failed to parse Profile Image URL", code: 104)
        }
    }
}

struct UserRelationStats {
    var followers: Int
    var following: Int
}
