//
//  TweetCellButton.swift
//  TwitterTutorial
//
//  Created by Apple on 29.07.2022.
//

import UIKit

class TweetCellButton: UIButton {
    
    init(imageName: String) {
        super.init(frame: .zero)
        setImage(UIImage(named: imageName), for: .normal)
        tintColor = .darkGray
        setDimensions(width: 20, height: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
