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
        feed.tabBarItem.image = UIImage(named: "home_unselected")
        let explore = ExploreController()
        explore.tabBarItem.image = UIImage(named: "search_unselected")
        let notifications = NotificationsController()
        notifications.tabBarItem.image = UIImage(named: "search_unselected")
        let conversations = ConversationsController()
        conversations.tabBarItem.image = UIImage(named: "search_unselected")
        
        viewControllers = [feed, explore, notifications, conversations]
        
    }
  

}
