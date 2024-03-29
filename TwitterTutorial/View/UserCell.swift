//
//  UserCell.swift
//  TwitterTutorial
//
//  Created by Apple on 04.08.2022.
//

import UIKit

class UserCell: UITableViewCell, ReusableView {
    
    //MARK: - Properties

    static var identifier: String {
        String(describing: self)
    }
    
    private var user: User? {
        didSet { fillCell() }
    }
    
    private let profileImageView = ProfileImageView()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "User Name"
        return label
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Full Name"
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(profileImageView)
        profileImageView.setSize(40)
        profileImageView.centerY(inView: self, leadingAnchor: leadingAnchor, paddingLeft: 12)
        
        let stackView = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        addSubview(stackView)
        stackView.centerY(inView: self, leadingAnchor: profileImageView.trailingAnchor, paddingLeft: 12)
    }
    
    func setUser(_ user: User) {
        self.user = user
    }
    
    private func fillCell() {
        guard let user = user else { return }
        profileImageView.sd_setImage(with: user.profileImageUrl)
        fullnameLabel.text = user.fullname
        usernameLabel.text = user.username
    }
}
