//
//  TweetCell.swift
//  TwitterTutorial
//
//  Created by Apple on 29.07.2022.
//

import UIKit
import SDWebImage
import ActiveLabel

protocol TweetCellDelegate: AnyObject {
    func didTapCommentButton(_ cell: TweetCell)
    func didTapRetweetButton(_ cell: TweetCell)
    func didTapLikeButton(_ cell: TweetCell)
    func didTapShareButton(_ cell: TweetCell)
    func didActiveLabel(_ cell: TweetCell, username: String)
}

class TweetCell: UICollectionViewCell, ReusableView {
    
//MARK: - Properties

    weak var delegate: TweetCellDelegate?

    static var identifier: String {
        String(describing: self)
    }
    
    var tweet: Tweet? {
        didSet { configure()}
    }

    private let replyLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.mentionColor = .twitterBlue
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private var profileImageView = ProfileImageView()
    
    private let captionLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.mentionColor = .twitterBlue
        label.hashtagColor = .twitterBlue
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let infoLabel = UILabel()

    let stackViewButtons = StackViewButtons()

//MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureMentionHendle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
//MARK: - Helpers
    
    func setProfileImageViewDelegate(_ delegate: ProfileImageViewDelegate) {
        profileImageView.delegate = delegate
    }

    func setStackViewButtonDelegate(_ delegate: StackViewButtonsDelegate) {
        stackViewButtons.delegate = delegate
    }
    
    func configure() {
        guard let tweet = tweet else { return }
        let viewModel = TweetViewModel(tweet: tweet)
        captionLabel.text = tweet.caption
        infoLabel.attributedText = viewModel.userInfoText
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        profileImageView.setUser(tweet.user)
        stackViewButtons.setLikeButtonImage(viewModel.likeButtonImage, withColor: viewModel.likeButtonTintColor)
        replyLabel.text = viewModel.replyText
        replyLabel.isHidden = viewModel.shouldHideRepplyLabel
    }
    
    private func configureUI() {
        profileImageView.setSize()
        configureLabelStackView()
        addSubview(stackViewButtons)
        stackViewButtons.delegate = self
        stackViewButtons.centerX(inView: self)
        stackViewButtons.anchor(bottom: bottomAnchor,  paddingBottom: 8)
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        addSeparateView(toView: self)
    }
    
    private func configureLabelStackView() {
        let stackView = UIStackView(arrangedSubviews: [infoLabel, captionLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 4

        let imageStackView = UIStackView(arrangedSubviews: [profileImageView, stackView])
        imageStackView.distribution = .fillProportionally
        imageStackView.spacing = 12
        imageStackView.alignment = .leading

        let stack = UIStackView(arrangedSubviews: [replyLabel, imageStackView])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillProportionally

        addSubview(stack)
        stack.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor,
                     paddingTop: 4, paddingLeading: 12, paddingTrailing: 12)

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

extension TweetCell: StackViewButtonsDelegate {

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
