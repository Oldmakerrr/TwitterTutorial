//
//  RegistrationController.swift
//  TwitterTutorial
//
//  Created by Apple on 17.07.2022.
//

import UIKit

class RegistrationController: UIViewController {
    
    //MARK: - Properties
    
    private let imagePicker = UIImagePickerController()
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleAddProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    private let emailContainerView = InputContainerView(image: UIImage(named: "ic_mail_outline_white_2x-1"), placeholder: "Email")
    
    private let passwordContainerView = InputContainerView(image: UIImage(named: "ic_lock_outline_white_2x"), placeholder: "Password")
    
    private let fullnameContainerView = InputContainerView(image: UIImage(named: "Iic_person_outline_white_2x"), placeholder: "Fullname")
    
    private let usernameContainerView = InputContainerView(image: UIImage(named: "Iic_person_outline_white_2x"), placeholder: "Username")
    
    private let alreadyHaveAccount: UIButton = {
        let button = Utilities().attributedButton("Already have an account?", " Log In")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    private let registrationButton: LoginButton = {
        let button = LoginButton(title: "Sign Up")
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Selectors
    
    @objc private func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleAddProfilePhoto() {
        present(imagePicker, animated: true)
    }
    
    @objc private func handleRegistration() {
        
    }
    
    //MARK: - Helper Methods
    
    private func configureUI() {
        view.backgroundColor = .twitterBlue
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 16)
        plusPhotoButton.setDimensions(width: 128, height: 128)
        imagePicker.delegate = self
        imagePicker.allowsEditing = true

        let stackView = UIStackView(arrangedSubviews: [emailContainerView,
                                                       passwordContainerView,
                                                       fullnameContainerView,
                                                       usernameContainerView,
                                                       registrationButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.anchor(top: plusPhotoButton.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor,
                         paddingTop: 32, paddingLeading: 16, paddingTrailing: 16)
        
        view.addSubview(alreadyHaveAccount)
        alreadyHaveAccount.anchor(leading: view.leadingAnchor,
                                     bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                     trailing: view.trailingAnchor,
                                     paddingLeading: 40, paddingTrailing: 40)
    }
}

//MARK: - UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else { return }
        plusPhotoButton.applyRoundCornerRadius()
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.imageView?.contentMode = .scaleAspectFill
        plusPhotoButton.imageView?.clipsToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3
        plusPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
    }

}
