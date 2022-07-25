//
//  RegistrationController.swift
//  TwitterTutorial
//
//  Created by Apple on 17.07.2022.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegistrationController: UIViewController {
    
    //MARK: - Properties
    
    private let imagePicker = UIImagePickerController()
    private var profileImage: UIImage?
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let emailContainerView = InputContainerView(image: UIImage(named: "ic_mail_outline_white_2x-1"), placeholder: "Email")
    
    private let passwordContainerView = InputContainerView(image: UIImage(named: "ic_lock_outline_white_2x"), placeholder: "Password")
    
    private let fullnameContainerView = InputContainerView(image: UIImage(named: "Iic_person_outline_white_2x"), placeholder: "Fullname")
    
    private let usernameContainerView = InputContainerView(image: UIImage(named: "Iic_person_outline_white_2x"), placeholder: "Username")
    
    private let alreadyHaveAccount = Utilities().attributedButton("Already have an account?", " Log In")
    
    private let registrationButton = AuthButton(title: "Sign Up")
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
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
        guard let email = emailContainerView.textField.text,
              let password = passwordContainerView.textField.text,
              let fullname = fullnameContainerView.textField.text,
              let username = usernameContainerView.textField.text else { return }
        guard let profileImage = profileImage else {
            print("DEBUG: Please select a profile image..")
            return
        }
        let credentials = AuthCredentials(email: email,
                                          password: password,
                                          fullname: fullname,
                                          username: username,
                                          profileImage: profileImage)
        AuthService.shared.registerUser(credentials: credentials) { error, reference in
            if let error = error {
                print("DEBUG: Error sigh up: \(error.localizedDescription)")
            } else {
                self.dismiss(animated: true)
                if let mainTabController = UIApplication.shared.keyWindow?.rootViewController as? MainTabController {
                    mainTabController.authenticateUser()
                }
            }
        }
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
    
    private func addTargets() {
        registrationButton.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        alreadyHaveAccount.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        plusPhotoButton.addTarget(self, action: #selector(handleAddProfilePhoto), for: .touchUpInside)
    }
}

//MARK: - UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else { return }
        self.profileImage = profileImage
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
