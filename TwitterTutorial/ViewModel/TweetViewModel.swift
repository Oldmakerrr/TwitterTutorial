//
//  TweetViewModel.swift
//  TwitterTutorial
//
//  Created by Apple on 31.07.2022.
//

import Foundation
import UIKit

struct TweetViewModel {

    //MARK: - Properties
    
    let tweet: Tweet
    let user: User
    
    var profileImageUrl: URL {
        return tweet.user.profileImageUrl
    }
    
    var timestamp: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: tweet.timestamp, to: now)
    }

    var userNameText: String {
        "@\(user.username)"
    }

    var headerTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm ∙ MM/dd/yyyy"
        return formatter.string(from: tweet.timestamp)
    }

    var retweetAttributedString: NSAttributedString {
        attributedString(withValue: tweet.retweetsCount, text: "Retweet")
    }


    var likesAttributedString: NSAttributedString {
        attributedString(withValue: tweet.likes, text: tweet.likes == 1 ? "Like" : "Likes")
    }
    
    var userInfoText: NSAttributedString {
        let title = NSMutableAttributedString(string: user.fullname,
                                              attributes: [.font:UIFont.boldSystemFont(ofSize: 14)])
        let subStringAttribute: [NSAttributedString.Key:Any] = [.font:UIFont.systemFont(ofSize: 14),
                                                                .foregroundColor: UIColor.lightGray]
        let userName = NSAttributedString(string: " @\(user.username)",
                                          attributes: subStringAttribute)
        title.append(userName)
        guard let timestamp = timestamp else { return title }
        let timestampString = NSAttributedString(string: " ・ \(timestamp)",
                                          attributes: subStringAttribute)
        title.append(timestampString)
        return title
    }

    var likeButtonTintColor: UIColor {
        tweet.didLike ? .red : .lightGray
    }

    var likeButtonImage: UIImage? {
        let name = tweet.didLike ? "like_filled" : "like"
        return UIImage(named: name)
    }

    var shouldHideRepplyLabel: Bool {
        !tweet.isReply
    }

    var replyText: String? {
        guard let replyingTo = tweet.replyingTo else { return nil }
        return "→ replying to @\(replyingTo)"
    }

    //MARK: - Lifecycle
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }

    //MARK: - Helpers

    private func attributedString(withValue value: Int, text: String) -> NSAttributedString {
        let title = NSMutableAttributedString(string: "\(value) ",
                                              attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        let subText = NSAttributedString(string: text,
                                         attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                      .foregroundColor: UIColor.lightGray])
        title.append(subText)
        return title
    }

    func size(forWidth width: CGFloat, withFont font: UIFont) -> CGSize {
        let mesurmentLabel = UILabel()
        mesurmentLabel.text = tweet.caption
        mesurmentLabel.font = font
        mesurmentLabel.numberOfLines = 0
        mesurmentLabel.lineBreakMode = .byWordWrapping
        mesurmentLabel.translatesAutoresizingMaskIntoConstraints = false
        mesurmentLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        return mesurmentLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
