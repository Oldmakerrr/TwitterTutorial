//
//  EditProfileFooter.swift
//  TwitterTutorial
//
//  Created by Vladimir Berezin on 02.12.22.
//

import UIKit

protocol EditProfileFooterDelegate: AnyObject {
    func didLogoutTapped(_ view: EditProfileFooter)
}

class EditProfileFooter: UIView {

    //MARK: - Properties

    weak var delegate: EditProfileFooterDelegate?

    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = .systemGroupedBackground
        button.layer.cornerRadius = 25
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()

    //MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
    }

    override func layoutSubviews() {
        addSubview(logoutButton)
        logoutButton.centerX(inView: self)
        logoutButton.anchor(top: topAnchor, paddingTop: 16)
        logoutButton.setDimensions(width: frame.width/2, height: 50)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func handleLogout() {
        delegate?.didLogoutTapped(self)
    }
}
