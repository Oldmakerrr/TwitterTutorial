//
//  UploadTweetController.swift
//  TwitterTutorial
//
//  Created by Apple on 28.07.2022.
//

import UIKit
import ActiveLabel

class UploadTweetController: UIViewController {
    
//MARK: - Properties
    
    private let user: User
    private let config: UploadTweetConfiguration
    private let viewModel: UploadTweetViewModel
    
    private let caprionTextView = InputTextView()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle(viewModel.actionButtonTitle, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        return button
    }()
    
    private lazy var profileImageView = ProfileImageView()

    private lazy var replyLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = viewModel.replyText
        label.mentionColor = .twitterBlue
        label.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        return label
    }()
    
//MARK: - Lifecycle
    
    init(user: User, config: UploadTweetConfiguration) {
        self.user = user
        self.config = config
        viewModel = UploadTweetViewModel(config: config)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton.addTarget(self, action: #selector(uploadTweet), for: .touchUpInside)
        configureUI()
        configureMentionHendle()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
//MARK: - Selectors
    
    @objc private func uploadTweet() {
        guard let caption = caprionTextView.text else { return }
        TweetService.shared.uploadTweet(caption: caption, type: config) { error, reference in
            if let error = error {
                print("DEBUG: Failed to upload tweet wuth error: \(error.localizedDescription)")
                return
            }
            if case .reply(let tweet) = self.config {
                NotificationService.shared.uploadNotification(type: .reply, tweet: tweet)
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
        profileImageView.setSize()
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
    
    private func configureStackView() {
        let imageCaptoinStack = UIStackView(arrangedSubviews: [profileImageView, caprionTextView])
        caprionTextView.placeholderLabel.text = viewModel.placeHolderText
        imageCaptoinStack.alignment = .leading
        imageCaptoinStack.axis = .horizontal
        imageCaptoinStack.spacing = 12

        let stackView = UIStackView(arrangedSubviews: [replyLabel, imageCaptoinStack])
        stackView.axis = .vertical
        stackView.spacing = 12

        view.addSubview(stackView)
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         leading: view.leadingAnchor, trailing: view.trailingAnchor,
                         paddingTop: 16, paddingLeading: 16, paddingTrailing: 16)
        replyLabel.isHidden = !viewModel.shouldShowReplyLabel
    }

    private func configureMentionHendle() {
        replyLabel.handleMentionTap { username in
            UserService.shared.fetchUser(withUsername: username) { user in
                let controller = ProfileController(user: user)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
}
