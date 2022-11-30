//
//  Constants.swift
//  TwitterTutorial
//
//  Created by Apple on 25.07.2022.
//

import FirebaseDatabase
import FirebaseStorage

let STORAGE_REF = Storage.storage().reference()
let STARAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_TWEETS = DB_REF.child("tweets")
let REF_USER_TWEETS = DB_REF.child("user-tweets")
let REF_USER_FOLLOWERS = DB_REF.child("user-followers")
let REF_USER_FOLLOWING = DB_REF.child("user-following")
let REF_TWEETS_REPLIES = DB_REF.child("tweet-replies")
