//
//  EditProfileHeader.swift
//  TwitterTutorial
//
//  Created by Vladimir Berezin on 02.12.22.
//

import UIKit

protocol EditProfileHeaderDelegate: AnyObject {
    func didTapChangePhotoButton(_ view: EditProfileHeader)
}

class EditProfileHeader: UIView {

    //MARK: - Properties

    weak var delegate: EditProfileHeaderDelegate?

    private let user: User

    private let profileImageView: ProfileImageView

    private let changePhotoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change Profile Photo", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    //MARK: - Lifecycle

    init(user: User) {
        self.user = user
        profileImageView = ProfileImageView(user: user)
        super.init(frame: .zero)
        configureUI()
        addTargets()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Selectors

    @objc private func handleChangeProfilePhoto() {
        delegate?.didTapChangePhotoButton(self)
    }

    //MARK: - Helpers

    private func configureUI() {
        backgroundColor = .twitterBlue
        addSubview(profileImageView)
        profileImageView.center(inView: self, yConstant: -16)
        profileImageView.setSize(100)
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = UIColor.white.cgColor

        addSubview(changePhotoButton)
        changePhotoButton.centerX(inView: self,
                                  topAnchor: profileImageView.bottomAnchor,
                                  paddingTop: 8)
        profileImageView.sd_setImage(with: user.profileImageUrl)
    }

    private func addTargets() {
        changePhotoButton.addTarget(self, action: #selector(handleChangeProfilePhoto), for: .touchUpInside)
    }

    func setImage(_ image: UIImage?) {
        profileImageView.image = image
    }
}
