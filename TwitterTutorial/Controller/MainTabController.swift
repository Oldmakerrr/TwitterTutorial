//
//  MainTabController.swift
//  TwitterTutorial
//
//  Created by Apple on 15.07.2022.
//

import UIKit
import FirebaseAuth

class MainTabController: UITabBarController {
    
    //MARK: - Properties
    
    private var user: User? {
        didSet {
            let navigationController = viewControllers?[0] as? UINavigationController
            guard let feedController = navigationController?.viewControllers.first as? FeedController else { return }
            feedController.user = user
        }
    }
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        return button
    }()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .twitterBlue
//        logUserOut()
        authenticateUser()
    }
    
    //MARK: - API
    
    func authenticateUser() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let navigationController = UINavigationController(rootViewController: LoginController())
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true)
            }
        } else {
            configureUI()
            configureViewControllers()
            fetchUser()
        }
    }
    
    private func fetchUser() {
        UserService.shared.fetchUser { user in
            self.user = user
        }
    }
    
    private func logUserOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("DEBUG: Failed to sigh out with error: \(error.localizedDescription)")
        }
    }
    
    //MARK: - Selectors
    
    @objc private func actionButtonTapped() {
        print("Button pressed")
    }
    
    //MARK: - Helpers Methods
    
    private func configureUI() {
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            trailing: view.trailingAnchor,
                            paddingBottom: 64, paddingTrailing: 16, width: 56, height: 56)
        actionButton.applyRoundCornerRadius()
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    private func configureViewControllers() {
        
        let feed = FeedController()
        let feedNavigationController = templateNavigationController(image: UIImage(named: "home_unselected"),
                                                                    rootViewController: feed)
        
        let explore = ExploreController()
        let exploreNavigationController = templateNavigationController(image: UIImage(named: "search_unselected"),
                                                                       rootViewController: explore)
        
        let notifications = NotificationsController()
        let notificationsNavigationController = templateNavigationController(image: UIImage(named: "like_unselected"),
                                                                             rootViewController: notifications)
        
        let conversations = ConversationsController()
        let conversationsNavigationController = templateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1"),
                                                                             rootViewController: conversations)
        
        viewControllers = [feedNavigationController,
                           exploreNavigationController,
                           notificationsNavigationController,
                           conversationsNavigationController]
        
    }
    
    private func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.image = image
        return navigationController
    }

}
