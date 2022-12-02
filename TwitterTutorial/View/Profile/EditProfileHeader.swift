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

    private let profileImage: ProfileImageView

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
        profileImage = ProfileImageView(user: user)
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
        addSubview(profileImage)
        profileImage.center(inView: self, yConstant: -16)
        profileImage.setSize(100)
        profileImage.layer.borderWidth = 3
        profileImage.layer.borderColor = UIColor.white.cgColor

        addSubview(changePhotoButton)
        changePhotoButton.centerX(inView: self,
                                  topAnchor: profileImage.bottomAnchor,
                                  paddingTop: 8)
        profileImage.sd_setImage(with: user.profileImageUrl)
    }

    private func addTargets() {
        changePhotoButton.addTarget(self, action: #selector(handleChangeProfilePhoto), for: .touchUpInside)
    }
}
