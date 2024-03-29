//
//  EditProfileController.swift
//  TwitterTutorial
//
//  Created by Vladimir Berezin on 02.12.22.
//

import UIKit

protocol EditProfileControllerDelegate: AnyObject {
    func controller(_ controller: EditProfileController, wantsToUpdate user: User)
    func handleLogout()
}

class EditProfileController: UITableViewController {

    //MARK: - Properties

    weak var delegate: EditProfileControllerDelegate?

    private var user: User
    private var selectedImage: UIImage? {
        didSet { headerView.setImage(selectedImage) }
    }
    private let headerView: EditProfileHeader
    private let footerView = EditProfileFooter()
    private let imagePicker = UIImagePickerController()
    private var isUserInfoChanged = false
    private var isImageChanged: Bool {
        selectedImage != nil
    }

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
        configureImagePicker()
    }

    //MARK: - Selectors

    @objc private func handleCancel() {
        dismiss(animated: true)
    }

    @objc private func handleDone() {
        view.endEditing(true)
        guard isImageChanged || isUserInfoChanged else { return }
        updateUserData()
    }

    //MARK: - API

    private func updateUserData() {
        if isImageChanged && !isUserInfoChanged {
            UserService.shared.updateProfileImage(image: selectedImage) { [self] imageProfileUrl in
                self.user.profileImageUrl = imageProfileUrl
                delegate?.controller(self, wantsToUpdate: user)
            }
        }

        if !isImageChanged && isUserInfoChanged {
            UserService.shared.saveUserData(user: user) { [self] error, reference in
                delegate?.controller(self, wantsToUpdate: user)
            }
        }

        if isImageChanged && isUserInfoChanged {
            let group = DispatchGroup()
            DispatchQueue.global().async(group: group) { [self] in
                group.enter()
                UserService.shared.saveUserData(user: user) { error, reference in
                    group.leave()
                }
                group.enter()
                UserService.shared.updateProfileImage(image: selectedImage) { imageProfileUrl in
                    self.user.profileImageUrl = imageProfileUrl
                    group.leave()
                }
            }
            group.notify(queue: .main) { [self] in
                delegate?.controller(self, wantsToUpdate: user)
            }
        }
    }

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
    }

    private func configureTableView() {
        tableView.tableHeaderView = headerView
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: EditProfileCell.identifier)
        tableView.isScrollEnabled = false
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        headerView.delegate = self
        tableView.tableFooterView = footerView
        footerView.delegate = self
    }

    private func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
}

//MARK: - UITableViewDataSource

extension EditProfileController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileOption.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EditProfileCell.identifier, for: indexPath) as! EditProfileCell
        cell.delegate = self
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
        present(imagePicker, animated: true)
    }

}

//MARK: - UIImagePickerControllerDelegate

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        selectedImage = image
        dismiss(animated: true)
    }
}

//MARK: - EditProfileCellDelegate

extension EditProfileController: EditProfileCellDelegate {

    func didUpdateUserInfo(_ cell: EditProfileCell) {
        guard let viewModel = cell.viewModel, let value = cell.infoTextField.text else { return }
        isUserInfoChanged = true
        let option = viewModel.option
        switch option {
        case .fullname:
            user.fullname = value
        case .username:
            user.username = value
        case .bio:
            user.bio = cell.bioTextView.text
        }
    }

}

//MARK: - EditProfileFooterDelegate

extension EditProfileController: EditProfileFooterDelegate {

    func didLogoutTapped(_ view: EditProfileFooter) {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            self.dismiss(animated: true) {
                self.delegate?.handleLogout()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
}
