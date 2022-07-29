//
//  UploadTweetController.swift
//  TwitterTutorial
//
//  Created by Apple on 28.07.2022.
//

import UIKit

class UploadTweetController: UIViewController {
    
//MARK: - Properties
    
    private let user: User
    
    private let caprionTextView = CaptionTextView()
    
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
    
    private let profileImageView = ProfileImageView()
    
//MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton.addTarget(self, action: #selector(uploadTweet), for: .touchUpInside)
        configureUI()
    }
    
//MARK: - Selectors
    
    @objc private func uploadTweet() {
        guard let caption = caprionTextView.text else { return }
        TweetService.shared.uploadTweet(caption: caption) { error, reference in
            if let error = error {
                print("DEBUG: Failed to upload tweet wuth error: \(error.localizedDescription)")
                return
            }
            self.dismiss(animated: true)
        }
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true)
    }
    
//MARK: - API
    
//MARK: - Helper Methods
    
    private func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        configureStackView()
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
    
    private func configureStackView() {
        let stackView = UIStackView(arrangedSubviews: [profileImageView, caprionTextView])
        view.addSubview(stackView)
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         leading: view.leadingAnchor, trailing: view.trailingAnchor,
                         paddingTop: 16, paddingLeading: 16, paddingTrailing: 16)
        stackView.axis = .horizontal
        stackView.spacing = 12
    }
    
}
