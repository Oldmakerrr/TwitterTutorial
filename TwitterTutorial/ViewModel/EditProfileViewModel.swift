//
//  EditProfileViewModel.swift
//  TwitterTutorial
//
//  Created by Vladimir Berezin on 02.12.22.
//

import Foundation

enum EditProfileOption: Int, CaseIterable {
    case fullname
    case username
    case bio

    var description: String {
        switch self {
        case .fullname:
            return "Name"
        case .username:
            return "Username"
        case .bio:
            return "Bio"
        }
    }
}

struct EditProfileViewModel {

    private let user: User
    let option: EditProfileOption

    var shouldHideTextField: Bool {
        option == .bio
    }

    var shuldHideTextView: Bool {
        option != .bio
    }

    var titleText: String {
        option.description
    }

    var optionValue: String? {
        switch option {
        case .fullname: return user.fullname
        case .username: return user.username
        case .bio: return user.bio
        }
    }

    var placeholder: String {
        switch option {
        case .fullname: return "Name"
        case .username: return "Username"
        case .bio: return "Bio"
        }
    }

    init(user: User, option: EditProfileOption) {
        self.user = user
        self.option = option
    }

}
