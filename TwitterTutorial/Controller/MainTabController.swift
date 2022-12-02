//
//  MainTabController.swift
//  TwitterTutorial
//
//  Created by Apple on 15.07.2022.
//

import UIKit
import FirebaseAuth

enum ActionButtonConfiguration {
    case tweet
    case message
}

class MainTabController: UITabBarController {
    
    //MARK: - Properties

    private var buttonConfig: ActionButtonConfiguration = .tweet
    
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
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
        }
    }
    
    //MARK: - Selectors
    
    @objc private func actionButtonTapped() {
        let contrller: UIViewController
        switch buttonConfig {
        case .tweet:
            guard let user = user else { return }
            contrller = UploadTweetController(user: user, config: .tweet)
        case .message:
            contrller = SearchController(config: .messages)
        }
        let navigation = UINavigationController(rootViewController: contrller)
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: true)
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
        delegate = self
        let layout = UICollectionViewFlowLayout()
        let feed = FeedController(collectionViewLayout: layout)
        let feedNavigationController = templateNavigationController(image: UIImage(named: "home_unselected"),
                                                                    rootViewController: feed)
        
        let explore = SearchController(config: .userSearch)
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

//MARK: - UITabBarControllerDelegate

extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let index = viewControllers?.firstIndex(of: viewController)
        buttonConfig = index == 3 ? .message : .tweet
        let imageName = index == 3 ? "mail" : "new_tweet"
        actionButton.setImage(UIImage(named: imageName), for: .normal)
    }
}
