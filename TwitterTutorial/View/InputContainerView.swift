//
//  InputContainerView.swift
//  TwitterTutorial
//
//  Created by Apple on 18.07.2022.
//

import UIKit

class InputContainerView: UIView {
    
    //MARK: - Properties
    
    private let image: UIImage?
    private let placeholder: String?
    
    private let imageView = UIImageView()
    let textField = UITextField()
    
    //MARK: - Lifecycle
    
    init(image: UIImage? = nil, placeholder: String? = nil) {
        self.image = image
        self.placeholder = placeholder
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Methods
    
    private func configureUI() {
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        addSubview(textField)
        configureImageView()
        configureTextField()
        configureDividedView()
    }
    
    private func configureImageView() {
        if let image = image {
            addSubview(imageView)
            imageView.image = image
            imageView.tintColor = .white
            imageView.anchor(leading: leadingAnchor, bottom: bottomAnchor, paddingLeading: 8, paddingBottom: 8)
            imageView.setDimensions(width: 24, height: 24)
            textField.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8).isActive = true
        } else {
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        }
    }
    
    private func configureTextField() {
        textField.anchor(bottom: bottomAnchor, trailing: trailingAnchor, paddingBottom: 8)
        textField.textColor = .white
        textField.font = UIFont.systemFont(ofSize: 16)
        if let placeholder = placeholder {
            textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            if placeholder == "Password" {
                textField.isSecureTextEntry = true
            }
        }
    }
    
    private func configureDividedView() {
        let view = UIView()
        view.backgroundColor = .white
        addSubview(view)
        view.anchor(leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, height: 0.75)
    }
}
