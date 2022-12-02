//
//  EditProfileController.swift
//  TwitterTutorial
//
//  Created by Vladimir Berezin on 02.12.22.
//

import UIKit

class EditProfileController: UITableViewController {

    //MARK: - Properties

    let user: User

    //MARK: - Lifecycle

    init(user: User) {
        self.user = user
        super.init(style: .plain)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }

    //MARK: - Selectors

    @objc private func handleCancel() {
        dismiss(animated: true)
    }

    @objc private func handleDone() {
        dismiss(animated: true)
        print("DEBUG: Tapped done button..")
    }

    //MARK: - API

    //MARK: - Helpers

    private func configureNavigationBar() {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .twitterBlue
            appearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0),
                                              .foregroundColor: UIColor.white]
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationController?.navigationBar.barTintColor = .twitterBlue
            navigationController?.navigationBar.barStyle = .black
            navigationController?.navigationBar.isTranslucent = false
        }
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = "Edit Profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
}
