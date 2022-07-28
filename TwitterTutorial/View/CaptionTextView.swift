//
//  CaptionTextView.swift
//  TwitterTutorial
//
//  Created by Apple on 28.07.2022.
//

import UIKit

class CaptionTextView: UITextView {
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "What's happening?"
        return label
    }()
    
    //MARK: Lifecycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 16)
        isScrollEnabled = false
        heightAnchor.constraint(equalToConstant: 300).isActive = true
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, leading: leadingAnchor,
                                paddingTop: 8, paddingLeading: 4)
        setNotification()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
        
    }
    
//MARK: Selectors
    
    @objc private func handleTextInputChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
}
