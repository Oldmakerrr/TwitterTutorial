//
//  ProfileImageView.swift
//  TwitterTutorial
//
//  Created by Apple on 29.07.2022.
//

import UIKit

class ProfileImageView: UIImageView {
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        contentMode = .scaleAspectFill
        clipsToBounds = true
        setDimensions(width: 48, height: 48)
        layer.cornerRadius = 48 / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
