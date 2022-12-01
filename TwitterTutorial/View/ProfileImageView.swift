//
//  ProfileImageView.swift
//  TwitterTutorial
//
//  Created by Apple on 29.07.2022.
//

import UIKit

protocol ProfileImageViewDelegate: AnyObject {
    func didTapped(_ view: ProfileImageView, _ user: User?)
}

class ProfileImageView: UIImageView {
    
    weak var delegate: ProfileImageViewDelegate?

    private var user: User?
    
    init(user: User? = nil, frame: CGRect = .zero) {
        self.user = user
        super.init(frame: frame)
        contentMode = .scaleAspectFill
        clipsToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
        backgroundColor = .twitterBlue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapAction() {
        delegate?.didTapped(self, user)
    }
    
    func setUser(_ user: User) {
        self.user = user
    }

    func setSize(_ size: CGFloat = 48) {
        setDimensions(width: size, height: size)
        layer.cornerRadius = size / 2
    }
}
