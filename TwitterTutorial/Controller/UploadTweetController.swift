//
//  UploadTweetController.swift
//  TwitterTutorial
//
//  Created by Apple on 28.07.2022.
//

import UIKit

class UploadTweetController: UIViewController {
    
//MARK: - Properties
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        return button
    }()
    
//MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton.addTarget(self, action: #selector(uploadTweet), for: .touchUpInside)
        configureUI()
    }
    
//MARK: - Selectors
    
    @objc private func uploadTweet() {
        
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true)
    }
    
//MARK: - API
    
//MARK: - Helper Methods
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
    
}
