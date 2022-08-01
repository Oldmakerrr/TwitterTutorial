//
//  ProfileHeader.swift
//  TwitterTutorial
//
//  Created by Apple on 01.08.2022.
//

import UIKit

class ProfileHeader: UICollectionReusableView {
    
    //MARK: - Properies
    
    private let profileFilterView = ProfileFilterView()
    
    private let underlineView = UIView()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor, leading: view.leadingAnchor,
                          paddingTop: .screenHeight * 0.05,
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
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 80 / 2
        return imageView
    }()
    
    private let editProfileFollowButton: UIButton = {
        let button = UIButton()
        button.setTitle("Loading", for: .normal)
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 1.25
        button.layer.cornerRadius = 18
        button.layer.masksToBounds = true
        button.setTitleColor(.twitterBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    //Labels
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.text = "Eddie Brock"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Venom"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "This is a user bio that will span more than one line for tset purpose."
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        addSubview(containerView)
        containerView.anchor(top: topAnchor,
                             leading: leadingAnchor,
                             trailing: trailingAnchor,
                             height: .screenHeight * 0.16)
        addSubview(profileImageView)
        profileImageView.anchor(top: containerView.bottomAnchor, leading: leadingAnchor, paddingTop: -24, paddingLeading: 8)
        profileImageView.setDimensions(width: 80, height: 80)
        configureButtons()
        configureUserDetailsStackView()
        addSubview(profileFilterView)
        profileFilterView.delegate = self
        profileFilterView.anchor(leading: leadingAnchor,
                                 bottom: bottomAnchor,
                                 trailing: trailingAnchor, height: 50)
        addSubview(underlineView)
        underlineView.backgroundColor = .twitterBlue
        underlineView.anchor(leading: leadingAnchor, bottom: bottomAnchor,
                             width: frame.width / 3, height: 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc private func backButtonHandle() {
        
    }
    
    @objc private func handleEditProfileFollow() {
        
    }
    
    //MARK: - Helper functions
    
    private func configureButtons() {
        backButton.addTarget(self, action: #selector(backButtonHandle), for: .touchUpInside)
        backButton.setImage(UIImage(named: "baseline_arrow_back_white_24dp"), for: .normal)
        editProfileFollowButton.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        addSubview(editProfileFollowButton)
        editProfileFollowButton.setDimensions(width: 100, height: 36)
        editProfileFollowButton.anchor(top: containerView.bottomAnchor, trailing: trailingAnchor,
                                       paddingTop: 12, paddingTrailing: 12)
    }
    
    private func configureUserDetailsStackView() {
        let stackView = UIStackView(arrangedSubviews: [fullnameLabel,
                                                       usernameLabel,
                                                       bioLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        addSubview(stackView)
        stackView.anchor(top: profileImageView.bottomAnchor,
                         leading: leadingAnchor,
                         trailing: trailingAnchor,
                         paddingTop: 8, paddingLeading: 12, paddingTrailing: 12)
    }
    
}

//MARK: - ProfileFilterViewDelegate

extension ProfileHeader: ProfileFilterViewDelegate {
    
    func didSelect(_ view: ProfileFilterView, cell: ProfileFilterCell) {
        let xPosition = cell.frame.origin.x
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = xPosition
        }
    }
}
