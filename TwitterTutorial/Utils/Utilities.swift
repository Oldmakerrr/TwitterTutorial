//
//  Utilities.swift
//  TwitterTutorial
//
//  Created by Apple on 22.07.2022.
//

import UIKit

class Utilities {
    
    func attributedButton(_ firstPart: String, _ secondPart: String) -> UIButton {
        let button = UIButton(type: .system)
        let attributeTitle = NSMutableAttributedString(string: firstPart, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.white])
        attributeTitle.append(NSMutableAttributedString(string: secondPart, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.white]))
        button.setAttributedTitle(attributeTitle, for: .normal)
        return button
    }
    
}
