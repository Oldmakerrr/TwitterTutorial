//
//  EditProfileController.swift
//  TwitterTutorial
//
//  Created by Vladimir Berezin on 02.12.22.
//

import UIKit

class EditProfileController: UITableViewController {

    //MARK: - Properties

    private let user: User
    private let headerView: EditProfileHeader

    //MARK: - Lifecycle

    init(user: User) {
        self.user = user
        headerView = EditProfileHeader(user: user)
        super.init(style: .plain)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
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
            appearance.shadowColor = .clear
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

    private func configureTableView() {
        tableView.tableHeaderView = headerView
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: EditProfileCell.identifier)
        tableView.isScrollEnabled = false
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        headerView.delegate = self
        tableView.tableFooterView = UIView()
    }
}

//MARK: - UITableViewDataSource

extension EditProfileController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileOption.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EditProfileCell.identifier, for: indexPath) as! EditProfileCell
        if let option = EditProfileOption(rawValue: indexPath.row) {
            cell.viewModel = EditProfileViewModel(user: user, option: option)
        }
        return cell
    }
}

//MARK: - UITableViewDelegate

extension EditProfileController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let option = EditProfileOption.init(rawValue: indexPath.row) else { return 0 }
        return option == .bio ? 100 : 48
    }
}

//MARK: - EditProfileHeaderDelegate

extension EditProfileController: EditProfileHeaderDelegate {

    func didTapChangePhotoButton(_ view: EditProfileHeader) {
        print("Tapped Change Photo Button..")
    }

}
