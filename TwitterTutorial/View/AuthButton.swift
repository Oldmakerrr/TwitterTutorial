//
//  LoginButton.swift
//  TwitterTutorial
//
//  Created by Apple on 22.07.2022.
//

import UIKit

class AuthButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(.twitterBlue, for: .normal)
        backgroundColor = .white
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        layer.cornerRadius = 5
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
