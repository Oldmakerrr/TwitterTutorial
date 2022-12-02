//
//  ProfileHeader.swift
//  TwitterTutorial
//
//  Created by Apple on 01.08.2022.
//

import UIKit

protocol ProfileHeaderDelegate: AnyObject {
    func didTappedBack(_ view: ProfileHeader)
    func handleEditProfileFollow(_ view: ProfileHeader)
    func didChangeFilterOptoin(_ view: ProfileHeader, selectedFilter: ProfileFilterOptions)
}

class ProfileHeader: UICollectionReusableView {

    //MARK: - Properies
    
    weak var delegate: ProfileHeaderDelegate?
    
    private var user: User? {
        didSet { configureViewModel() }
    }
    
    private var viewModel: ProfileHeaderViewModel?
    
    private let profileFilterView = ProfileFilterView()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor,
                          leading: view.leadingAnchor,
                          paddingTop: 16,
                          paddingLeading: 16)
        backButton.setDimensions(width: 30, height: 30)
        return view
    }()
    
    private let backButton = UIButton()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 4
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 80 / 2
        return imageView
    }()
    
    private let editProfileFollowButton = FollowButton()
    
    //Labels
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let followingButton = UIButton()
    
    private let followersButton = UIButton()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc private func backButtonHandle() {
        delegate?.didTappedBack(self)
    }
    
    @objc private func handleEditProfileFollow() {
        delegate?.handleEditProfileFollow(self)
    }
    
    @objc private func handleFollowersTapped() {
        print("DEBUG: FOLLOWERS")
    }
    
    @objc private func handleFollowingTapped() {
        print("DEBUG: FOLLOWING")
    }
    
    //MARK: - Helper functions

    private func configureUI() {
        backgroundColor = .white
        addSubview(containerView)
        containerView.anchor(top: topAnchor,
                             leading: leadingAnchor,
                             trailing: trailingAnchor,
                             height: .screenHeight * 0.1)
        addSubview(profileImageView)
        profileImageView.anchor(top: containerView.bottomAnchor, leading: leadingAnchor, paddingTop: -24, paddingLeading: 8)
        profileImageView.setDimensions(width: 80, height: 80)
        configureButtons()
        let userDetailStackView = UIStackView(arrangedSubviews: [fullnameLabel,
                                                                 usernameLabel,
                                                                 bioLabel])
        configureUserDetailsStackView(stackView: userDetailStackView)
        addGestureToLabel()
        let followStackView = UIStackView(arrangedSubviews: [followingButton, followersButton])
        followStackView.axis = .horizontal
        followStackView.distribution = .fillEqually
        followStackView.spacing = 8
        addSubview(followStackView)
        followStackView.anchor(top: userDetailStackView.bottomAnchor, leading: leadingAnchor,
                               paddingTop: 8, paddingLeading: 12)
        addSubview(profileFilterView)
        profileFilterView.delegate = self
        profileFilterView.anchor(top: followStackView.bottomAnchor,
                                 leading: leadingAnchor,
                                 bottom: bottomAnchor,
                                 trailing: trailingAnchor, height: 50)
    }
    
    private func configureButtons() {
        backButton.addTarget(self, action: #selector(backButtonHandle), for: .touchUpInside)
        backButton.setImage(UIImage(named: "baseline_arrow_back_white_24dp"), for: .normal)
        editProfileFollowButton.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        addSubview(editProfileFollowButton)
        editProfileFollowButton.setDimensions(width: 100, height: 36)
        editProfileFollowButton.anchor(top: containerView.bottomAnchor, trailing: trailingAnchor,
                                       paddingTop: 12, paddingTrailing: 12)
    }
    
    private func configureUserDetailsStackView(stackView: UIStackView) {
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        addSubview(stackView)
        stackView.anchor(top: profileImageView.bottomAnchor,
                         leading: leadingAnchor,
                         trailing: trailingAnchor,
                         paddingTop: 8, paddingLeading: 12, paddingTrailing: 12)
    }
    
    private func addGestureToLabel() {
        followingButton.addTarget(self, action: #selector(handleFollowingTapped), for: .touchUpInside)
        followersButton.addTarget(self, action: #selector(handleFollowersTapped), for: .touchUpInside)
        followersButton.setTitleColor(.black, for: .normal)
        followingButton.setTitleColor(.black, for: .normal)
    }
    
    private func configureViewModel() {
        guard let user = user else { return }
        viewModel = ProfileHeaderViewModel(user: user)
        fullnameLabel.text = user.fullname
        usernameLabel.text = viewModel?.usernameText
        profileImageView.sd_setImage(with: user.profileImageUrl)
        editProfileFollowButton.setTitle(viewModel?.actionButtonTitle, for: .normal)
        followingButton.setAttributedTitle(viewModel?.followingString, for: .normal)
        followersButton.setAttributedTitle(viewModel?.followersString, for: .normal)
        if let bio = user.bio, !bio.isEmpty {
            bioLabel.text = bio
        }
    }
    
    func setupUser(_ user: User) {
        self.user = user
    }

    func updateButtonTitle(isFollowed: Bool) {
        let title = isFollowed ? "Following" : "Follow"
        editProfileFollowButton.setTitle(title, for: .normal)
    }
    
}

//MARK: - ProfileFilterViewDelegate

extension ProfileHeader: ProfileFilterViewDelegate  {

    func didSelect(_ view: ProfileFilterView, selectedFilter: ProfileFilterOptions) {
        delegate?.didChangeFilterOptoin(self, selectedFilter: selectedFilter)
    }

}
