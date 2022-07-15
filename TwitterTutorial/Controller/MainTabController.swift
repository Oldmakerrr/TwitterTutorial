//
//  MainTabController.swift
//  TwitterTutorial
//
//  Created by Apple on 15.07.2022.
//

import UIKit

class MainTabController: UITabBarController {
    
    //MARK: - Properties
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
        
    }
    
    //MARK: - Helpers Methods
    
    private func configureViewControllers() {
        
        let feed = FeedController()
        let feedNavigationController = templateNavigationController(image: UIImage(named: "home_unselected"),
                                                                    rootViewController: feed)
        
        let explore = ExploreController()
        let exploreNavigationController = templateNavigationController(image: UIImage(named: "search_unselected"),
                                                                       rootViewController: explore)
        
        let notifications = NotificationsController()
        let notificationsNavigationController = templateNavigationController(image: UIImage(named: "search_unselected"),
                                                                             rootViewController: notifications)
        
        let conversations = ConversationsController()
        let conversationsNavigationController = templateNavigationController(image: UIImage(named: "search_unselected"),
                                                                             rootViewController: conversations)
        
        viewControllers = [feedNavigationController,
                           exploreNavigationController,
                           notificationsNavigationController,
                           conversationsNavigationController]
        
    }
    
    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.image = image
        return navigationController
    }

}
