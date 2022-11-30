//
//  StackViewButtons.swift
//  TwitterTutorial
//
//  Created by Vladimir Berezin on 30.11.22.
//

import UIKit

protocol StackViewButtonsDelegate: AnyObject {
    func didTapCommentButton(_ view: StackViewButtons)
    func didTapRetweetButton(_ view: StackViewButtons)
    func didTapLikeButton(_ view: StackViewButtons)
    func didTapShareButton(_ view: StackViewButtons)
}

class StackViewButtons: UIStackView {

    weak var delegate: StackViewButtonsDelegate?

    private let commentButton = TweetCellButton(imageName: "comment")

    private let retweetButton = TweetCellButton(imageName: "retweet")

    private let likeButton = TweetCellButton(imageName: "like")

    private let shareButton = TweetCellButton(imageName: "share")

    override init(frame: CGRect) {
        super.init(frame: frame)
        conigureUI()
        addTargetsToButtons()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func conigureUI() {
        addArrangedSubview(commentButton)
        addArrangedSubview(retweetButton)
        addArrangedSubview(likeButton)
        addArrangedSubview(shareButton)
        axis = .horizontal
        spacing = 72
    }

    private func addTargetsToButtons() {
        commentButton.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        retweetButton.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
    }

    func setLikeButtonImage(_ image: UIImage?, withColor color: UIColor) {
        likeButton.setImage(image, for: .normal)
        likeButton.tintColor = color
    }

    @objc private func handleCommentTapped() {
        delegate?.didTapCommentButton(self)
    }
    @objc private func handleRetweetTapped() {
        delegate?.didTapRetweetButton(self)
    }
    @objc private func handleLikeTapped() {
        delegate?.didTapLikeButton(self)
    }
    @objc private func handleShareTapped() {
        delegate?.didTapShareButton(self)
    }

}
