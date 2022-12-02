//
//  TweetHeader.swift
//  TwitterTutorial
//
//  Created by Vladimir Berezin on 30.11.22.
//

import UIKit
import ActiveLabel

protocol ReusableView {
    static var identifier: String { get }
}

protocol TweetHeaderDelegate: AnyObject {
    func showActionSheet(_ view: TweetHeader)
    func didTapCommentButton(_ view: TweetHeader)
    func didTapRetweetButton(_ view: TweetHeader)
    func didTapLikeButton(_ view: TweetHeader)
    func didTapShareButton(_ view: TweetHeader)
    func didActiveLabel(_ cell: TweetHeader, username: String)
}

class TweetHeader: UICollectionReusableView, ReusableView {

    //MARK: - Properties

    weak var delegate: TweetHeaderDelegate?

    var tweet: Tweet? {
        didSet { updateUI() }
    }

    static var identifier: String {
        String(describing: self)
    }

    private let profileImageView = ProfileImageView()

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()

    private let fullnameLabel = UILabel()

    private let captionLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.mentionColor = .twitterBlue
        label.hashtagColor = .twitterBlue
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .lightGray
        label.textAlignment = .left
        return label
    }()

    private lazy var optionButton: UIButton = {
        let button = UIButton()
        button.tintColor = .lightGray
        button.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        return button
    }()

    private let replyLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.mentionColor = .twitterBlue
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    private let likesLabel = UILabel()

    private let retweetsLabel = UILabel()

    private lazy var statsView: UIView = {
        let view = UIView()
        let topDivider = UIView()
        topDivider.backgroundColor = .systemGroupedBackground
        view.addSubview(topDivider)
        topDivider.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingLeading: 8, height: 1)
        let stack = UIStackView(arrangedSubviews: [retweetsLabel, likesLabel])
        stack.axis = .horizontal
        stack.spacing = 12
        view.addSubview(stack)
        stack.centerY(inView: view)
        stack.anchor(leading: view.leadingAnchor, paddingLeading: 16)
        let bottonDivider = UIView()
        bottonDivider.backgroundColor = .systemGroupedBackground
        view.addSubview(bottonDivider)
        bottonDivider.anchor(leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, paddingLeading: 8, height: 1)
        return view
    }()

    private let stackViewButtons = StackViewButtons()

    //MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureMentionHendle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Selectors

    @objc private func showActionSheet() {
        delegate?.showActionSheet(self)
    }

    //MARK: - Helpers

    private func configureUI() {
        likesLabel.font = UIFont.systemFont(ofSize: 14)
        retweetsLabel.font = UIFont.systemFont(ofSize: 14)
        fullnameLabel.font = UIFont.systemFont(ofSize: 14)
        let labelStackView = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        labelStackView.axis = .vertical
        labelStackView.spacing = -4
        profileImageView.delegate = self
        profileImageView.setSize()
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, labelStackView])
        imageCaptionStack.spacing = 12

        let stack = UIStackView(arrangedSubviews: [replyLabel, imageCaptionStack])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillProportionally

        addSubview(stack)
        stack.anchor(top: topAnchor, leading: leadingAnchor, paddingTop: 16, paddingLeading: 16)
        addSubview(captionLabel)
        captionLabel.anchor(top: imageCaptionStack.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 12, paddingLeading: 16, paddingTrailing: 16)
        addSubview(dateLabel)
        dateLabel.anchor(top: captionLabel.bottomAnchor, leading: leadingAnchor, paddingTop: 20, paddingLeading: 16)
        addSubview(optionButton)
        optionButton.centerY(inView: imageCaptionStack)
        optionButton.anchor(trailing: trailingAnchor, paddingTrailing: 8)
        addSubview(statsView)
        statsView.anchor(top: dateLabel.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 12, height: 40)
        addSubview(stackViewButtons)
        stackViewButtons.delegate = self
        stackViewButtons.centerX(inView: self)
        stackViewButtons.anchor(top: statsView.bottomAnchor, paddingTop: 12)
    }

    private func updateUI() {
        guard let tweet = tweet else { return }
        let viewModel = TweetViewModel(tweet: tweet)
        captionLabel.text = tweet.caption
        fullnameLabel.text = tweet.user.fullname
        usernameLabel.text = viewModel.userNameText
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        dateLabel.text = viewModel.headerTimestamp
        retweetsLabel.attributedText = viewModel.retweetAttributedString
        likesLabel.attributedText = viewModel.likesAttributedString
        stackViewButtons.setLikeButtonImage(viewModel.likeButtonImage, withColor: viewModel.likeButtonTintColor)
        replyLabel.isHidden = viewModel.shouldHideRepplyLabel
        replyLabel.text = viewModel.replyText
    }

    func setDelegateToStackViewButtons(_ delegate: StackViewButtonsDelegate) {
        stackViewButtons.delegate = delegate
    }

    func setDelegateImageProfile(_ delegate: ProfileImageViewDelegate) {
        profileImageView.delegate = delegate
    }

    private func configureMentionHendle() {
        replyLabel.handleMentionTap { mention in
            self.delegate?.didActiveLabel(self, username: mention)
        }
        captionLabel.handleMentionTap { mention in
            self.delegate?.didActiveLabel(self, username: mention)
        }
    }

}

extension TweetHeader: ProfileImageViewDelegate {

    func didTapped(_ view: ProfileImageView, _ user: User?) {
        print("DEBUG: show user profile info..")
    }

}

extension TweetHeader: StackViewButtonsDelegate {
    func didTapCommentButton(_ view: StackViewButtons) {
        delegate?.didTapCommentButton(self)
    }

    func didTapRetweetButton(_ view: StackViewButtons) {
        delegate?.didTapRetweetButton(self)
    }

    func didTapLikeButton(_ view: StackViewButtons) {
        delegate?.didTapLikeButton(self)
    }

    func didTapShareButton(_ view: StackViewButtons) {
        delegate?.didTapShareButton(self)
    }

    
}
