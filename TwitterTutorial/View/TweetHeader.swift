//
//  TweetHeader.swift
//  TwitterTutorial
//
//  Created by Vladimir Berezin on 30.11.22.
//

import UIKit

protocol ReusableView {
    static var identifier: String { get }
}

class TweetHeader: UICollectionReusableView, ReusableView {

    //MARK: - Properties

    static var identifier: String {
        String(describing: self)
    }

    private let profileImageView = ProfileImageView()

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "User Name"
        label.textColor = .lightGray
        return label
    }()

    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Full Name"
        return label
    }()

    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Date"
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

    private let likesLabel: UILabel = {
        let label = UILabel()
        label.text = "0 Likes"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    private let retweetsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0 Retweets"
        return label
    }()

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

    //MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Selectors

    @objc private func showActionSheet() {
        print("DEBUG: Show action sheet..")
    }

    //MARK: - Helpers

    private func configureUI() {
        let labelStackView = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        labelStackView.axis = .vertical
        labelStackView.spacing = 2
        profileImageView.delegate = self
        profileImageView.backgroundColor = .twitterBlue
        profileImageView.setDimensions(width: 48, height: 48)
        profileImageView.layer.cornerRadius = 48 / 2
        let stackView = UIStackView(arrangedSubviews: [profileImageView, labelStackView])
        stackView.spacing = 12
        addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: leadingAnchor, paddingTop: 16, paddingLeading: 16)
        addSubview(captionLabel)
        captionLabel.anchor(top: stackView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 20, paddingLeading: 16, paddingTrailing: 16)
        addSubview(dateLabel)
        dateLabel.anchor(top: captionLabel.bottomAnchor, leading: leadingAnchor, paddingTop: 20, paddingLeading: 16)
        addSubview(optionButton)
        optionButton.centerY(inView: stackView)
        optionButton.anchor(trailing: trailingAnchor, paddingTrailing: 8)
        addSubview(statsView)
        statsView.anchor(top: dateLabel.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 20, height: 40)
    }

}

extension TweetHeader: ProfileImageViewDelegate {

    func didTapped(_ view: ProfileImageView, _ user: User?) {
        print("DEBUG: show user profile info..")
    }

}
