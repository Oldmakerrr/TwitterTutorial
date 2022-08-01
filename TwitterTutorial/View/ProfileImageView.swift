//
//  ProfileImageView.swift
//  TwitterTutorial
//
//  Created by Apple on 29.07.2022.
//

import UIKit

protocol ProfileImageViewDelegate: AnyObject {
    func didTapped(_ view: ProfileImageView)
}

class ProfileImageView: UIImageView {
    
    weak var delegate: ProfileImageViewDelegate?
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        contentMode = .scaleAspectFill
        clipsToBounds = true
        setDimensions(width: 48, height: 48)
        layer.cornerRadius = 48 / 2
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapAction() {
        delegate?.didTapped(self)
    }
}
