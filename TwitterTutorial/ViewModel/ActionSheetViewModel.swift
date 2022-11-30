//
//  ActionSheetViewModel.swift
//  TwitterTutorial
//
//  Created by Vladimir Berezin on 30.11.22.
//

import Foundation

struct ActionSheetViewModel {

    let user: User

    var options: [ActionSheetOption] {
        var results = [ActionSheetOption]()
        if user.isCurrentUser {
            results.append(.delete)
        } else {
            let followOption: ActionSheetOption = user.isFollowed ? .unfollow(user) : .follow(user)
            results.append(followOption)
        }
        results.append(.report)
        return results
    }

    init(user: User) {
        self.user = user
    }
}

enum ActionSheetOption {
    case follow(User)
    case unfollow(User)
    case report
    case delete

    var description: String {
        switch self {
        case .follow(let user):
            return "Follow @\(user.username)"
        case .unfollow(let user):
            return "Unfollow @\(user.username)"
        case .report:
            return "Report Tweet"
        case .delete:
            return "Delete Tweet"
        }
    }
}
