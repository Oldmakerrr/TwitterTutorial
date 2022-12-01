//
//  NotificationsController.swift
//  TwitterTutorial
//
//  Created by Apple on 15.07.2022.
//

import UIKit

class NotificationsController: UITableViewController {
    
    //MARK: - Properties

    private var notifications = [Notification]() {
        didSet { tableView.reloadData() }
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchNotifications()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }

    //MARK: - API

    private func fetchNotifications() {
        NotificationService.shared.fetchNotifications { notifications in
            self.notifications = notifications
        }
    }
    
    //MARK: - Helper Methods
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
    }

    private func configureTableView() {
        tableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.identifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
    }

    private func goToProfileController(user: User) {
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

//MARK: - UITableViewDataSource

extension NotificationsController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.identifier, for: indexPath) as! NotificationCell
        let notification = notifications[indexPath.row]
        cell.delegate = self
        cell.notification = notification
        return cell
    }
}

//MARK: - UITableViewDelegate

extension NotificationsController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tweetId = notifications[indexPath.row].tweetId else { return }
        TweetService.shared.fetchTweet(withTweetID: tweetId) { tweet in
            let controller = TweetController(tweet: tweet)
            self.navigationController?.pushViewController(controller, animated: true)
//            let navigation = UINavigationController(rootViewController: controller)
//            self.present(navigation, animated: true)
        }
    }
}

//MARK: - NotificationCellDelegate

extension NotificationsController: NotificationCellDelegate {

    func didTappedProfileImage(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else { return }
        goToProfileController(user: user)
    }
}
