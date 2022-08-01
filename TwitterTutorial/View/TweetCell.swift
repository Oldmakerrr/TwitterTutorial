//
//  TweetCell.swift
//  TwitterTutorial
//
//  Created by Apple on 29.07.2022.
//

import UIKit
import SDWebImage

class TweetCell: UICollectionViewCell {
    
//MARK: - Properties
    
    var tweet: Tweet? {
        didSet { configure() }
    }
    
    private let profileImageView = ProfileImageView()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let infoLabel = UILabel()
    
    private let commentButton = TweetCellButton(imageName: "comment")
    
    private let retweetButton = TweetCellButton(imageName: "retweet")
    
    private let likeButton = TweetCellButton(imageName: "like")
    
    private let shareButton = TweetCellButton(imageName: "share")
    
//MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTargetsToButtons()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
//MARK: - Helpers
    
    func setProfileImageViewDelegate(_ delegate: ProfileImageViewDelegate) {
        profileImageView.delegate = delegate
    }
    
    func configure() {
        guard let tweet = tweet else { return }
        let viewModel = TweetViewModel(tweet: tweet)
        captionLabel.text = tweet.caption
        infoLabel.attributedText = viewModel.userInfoText
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
    }
    
    private func configureUI() {
        profileImageView.backgroundColor = .twitterBlue
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, leading: leadingAnchor,
                                paddingTop: 8, paddingLeading: 8)
        configureLabelStackView()
        confugureButtonStackView()
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        addSeparateView(toView: self)
    }
    
    private func configureLabelStackView() {
        let stackView = UIStackView(arrangedSubviews: [infoLabel, captionLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        addSubview(stackView)
        stackView.anchor(top: profileImageView.topAnchor,
                         leading: profileImageView.trailingAnchor,
                         trailing: trailingAnchor,
                         paddingTop: 12, paddingLeading: 12)
    }
    
    private func confugureButtonStackView() {
        let stackView = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
        stackView.axis = .horizontal
        stackView.spacing = 72
        addSubview(stackView)
        stackView.centerX(inView: self)
        stackView.anchor(bottom: bottomAnchor,  paddingBottom: 8)
    }
    
    private func addTargetsToButtons() {
        commentButton.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        retweetButton.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
    }
    
//MARK: - Selectors

    @objc private func handleCommentTapped() {
        
    }
    @objc private func handleRetweetTapped() {
        
    }
    @objc private func handleLikeTapped() {
        
    }
    @objc private func handleShareTapped() {
        
    }
    
    
}
