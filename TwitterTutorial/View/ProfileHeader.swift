//
//  ProfileHeader.swift
//  TwitterTutorial
//
//  Created by Apple on 01.08.2022.
//

import UIKit

class ProfileHeader: UICollectionReusableView {
    
    //MARK: - Properies
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper functions
    
}
