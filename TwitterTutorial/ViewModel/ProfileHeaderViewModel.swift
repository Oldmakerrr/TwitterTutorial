//
//  ProfileHeaderViewModel.swift
//  TwitterTutorial
//
//  Created by Apple on 02.08.2022.
//

import Foundation
import UIKit

enum ProfileFilterOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description: String {
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Tweets & Replies"
        case .likes: return "Likes"
        }
    }
}

struct ProfileHeaderViewModel {
    
    private let user: User
    
    let usernameText: String
    
    var followersString: NSAttributedString? {
        return attributedText(withValue: user.stats?.followers ?? 0, text: "followers")
    }
    
    var followingString: NSAttributedString? {
        return attributedText(withValue: user.stats?.following ?? 0, text: "following")
    }
    
    var actionButtonTitle: String {
        if user.isCurrentUser {
            return "Edit Profile"
        }

        if !user.isFollowed && !user.isCurrentUser {
            return "Follow"
        }

        if user.isFollowed {
            return "Following"
        }
        return "Loading"
    }
    
    init(user: User) {
        self.user = user
        self.usernameText = "@" + user.username
    }
    
    private func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let title = NSMutableAttributedString(string: "\(value) ",
                                              attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        let subText = NSAttributedString(string: text,
                                         attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                      .foregroundColor: UIColor.lightGray])
        title.append(subText)
        return title
    }
}
