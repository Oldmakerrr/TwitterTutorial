//
//  TweetHeader.swift
//  TwitterTutorial
//
//  Created by Vladimir Berezin on 30.11.22.
//

import UIKit

protocol ReusableView {
    static var identifier: String { get }
}

class TweetHeader: UICollectionReusableView, ReusableView {

    //MARK: - Properties

    static var identifier: String {
        String(describing: self)
    }

    //MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
