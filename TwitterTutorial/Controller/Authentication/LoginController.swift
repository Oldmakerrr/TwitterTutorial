//
//  LoginController.swift
//  TwitterTutorial
//
//  Created by Apple on 17.07.2022.
//

import UIKit

class LoginController: UIViewController {
    
    //MARK: - Properties
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "TwitterLogo")
        return imageView
    }()
    
    private let emailContainerView = InputContainerView(image: UIImage(named: "ic_mail_outline_white_2x-1"), placeholder: "Email")
    
    private let passwordContainerView = InputContainerView(image: UIImage(named: "ic_lock_outline_white_2x"), placeholder: "Password")
    
    private let loginButton = AuthButton(title: "Log In")
    
    private let dontHaveAccountButton = Utilities().attributedButton("Don't have an account?", " Sign Up")
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Selectors
    
    @objc private func handleLogin() {
    }
    
    @objc private func handleShowSignUp() {
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - Helper Methods
    
    private func configureUI() {
        view.backgroundColor = .twitterBlue
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        logoImageView.setDimensions(width: 150, height: 150)
        
        let stackView = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.anchor(top: logoImageView.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor,
                         paddingLeading: 16, paddingTrailing: 16)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(leading: view.leadingAnchor,
                                     bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                     trailing: view.trailingAnchor,
                                     paddingLeading: 40, paddingTrailing: 40)
    }
    
    private func addTargets() {
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        dontHaveAccountButton.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
    }
}
