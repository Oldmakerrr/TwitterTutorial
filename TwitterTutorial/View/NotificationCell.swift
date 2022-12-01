//
//  NotificationCell.swift
//  TwitterTutorial
//
//  Created by Vladimir Berezin on 01.12.22.
//

import UIKit

protocol NotificationCellDelegate: AnyObject {
    func didTappedProfileImage(_ cell: NotificationCell)
    func didTappedFollow(_ cell: NotificationCell)
}

class NotificationCell: UITableViewCell, ReusableView {

    //MARK: - Properties

    weak var delegate: NotificationCellDelegate?

    var notification: Notification? {
        didSet { updateUI() }
    }

    static var identifier: String {
        String(describing: self)
    }

    private let profileImageView = ProfileImageView()

    private let notificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Some test notification message.."
        return label
    }()

    private let followButton = FollowButton()

    //MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Helpers

    private func configureUI() {
        selectionStyle = .none
        let stack = UIStackView(arrangedSubviews: [profileImageView, notificationLabel])
        stack.spacing = 8
        stack.alignment = .center
        contentView.addSubview(stack)
        stack.centerY(inView: contentView)
        stack.anchor(leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor,
                     paddingLeading: 12, paddingTrailing: 12)
        profileImageView.setSize(40)
        profileImageView.delegate = self
        setupFollowButton()
    }

    private func setupFollowButton() {
        contentView.addSubview(followButton)
        followButton.addTarget(self, action: #selector(handleFollow), for: .touchUpInside)
        followButton.centerY(inView: contentView)
        followButton.setDimensions(width: 88, height: 28)
        followButton.anchor(trailing: contentView.trailingAnchor, paddingTrailing: 12)
        followButton.layer.cornerRadius = 14
    }

    private func updateUI() {
        guard let notification = notification else { return }
        let viewModel = NotificationViewModel(notification: notification)
        notificationLabel.attributedText = viewModel.notificationText
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        followButton.isHidden = viewModel.shouldHideFollowButton
        followButton.setTitle(viewModel.followButtonTitle, for: .normal)
    }

    //MARK: - Selector

    @objc private func handleFollow() {
        delegate?.didTappedFollow(self)
    }
}

extension NotificationCell: ProfileImageViewDelegate {

    func didTapped(_ view: ProfileImageView, _ user: User?) {
        delegate?.didTappedProfileImage(self)
    }

}
