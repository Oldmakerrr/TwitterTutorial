//
//  FollowButton.swift
//  TwitterTutorial
//
//  Created by Vladimir Berezin on 01.12.22.
//

import UIKit

class FollowButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.borderColor = UIColor.twitterBlue.cgColor
        layer.borderWidth = 1.25
        layer.cornerRadius = 18
        layer.masksToBounds = true
        setTitleColor(.twitterBlue, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    }
}
