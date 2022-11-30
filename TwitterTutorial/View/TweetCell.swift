//
//  TweetCell.swift
//  TwitterTutorial
//
//  Created by Apple on 29.07.2022.
//

import UIKit
import SDWebImage

protocol TweetCellDelegate: AnyObject {
    func didTapCommentButton(_ cell: TweetCell)
    func didTapRetweetButton(_ cell: TweetCell)
    func didTapLikeButton(_ cell: TweetCell)
    func didTapShareButton(_ cell: TweetCell)
}

class TweetCell: UICollectionViewCell, ReusableView {
    
//MARK: - Properties

    weak var delegate: TweetCellDelegate?

    static var identifier: String {
        String(describing: self)
    }
    
    var tweet: Tweet? {
        didSet { configure() }
    }
    
    private var profileImageView = ProfileImageView()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
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
    }
    
    private func configureUI() {
        profileImageView.backgroundColor = .twitterBlue
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, leading: leadingAnchor,
                                paddingTop: 8, paddingLeading: 8)
        profileImageView.setDimensions(width: 48, height: 48)
        profileImageView.layer.cornerRadius = 48 / 2
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
        addSubview(stackView)
        stackView.anchor(top: profileImageView.topAnchor,
                         leading: profileImageView.trailingAnchor,
                         trailing: trailingAnchor, paddingLeading: 12, paddingTrailing: 20)
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
