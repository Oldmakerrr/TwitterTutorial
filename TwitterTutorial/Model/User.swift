//
//  User.swift
//  TwitterTutorial
//
//  Created by Apple on 26.07.2022.
//

import Foundation

enum UserError: Error {
    case fullnameNotExists
    case emailNotExists
    case usernameNotExists
    case profileImageUrlNotExists
}

struct User {
    let fullname: String
    let email: String
    let username: String
    let profileImageUrl: String
    let uid: String
    
    init(uid: String, dictionary: [String: AnyObject]) throws {
        self.uid = uid
        if let fullname = dictionary["fullname"] as? String {
            self.fullname = fullname
        } else {
            throw UserError.fullnameNotExists
        }
        if let email = dictionary["email"] as? String {
            self.email = email
        } else {
            throw UserError.emailNotExists
        }
        if let username = dictionary["username"] as? String {
            self.username = username
        } else {
            throw UserError.usernameNotExists
        }
        if let profileImageUrl = dictionary["profileImageUrl"] as? String {
            self.profileImageUrl = profileImageUrl
        } else {
            throw UserError.profileImageUrlNotExists
        }
    }
}
