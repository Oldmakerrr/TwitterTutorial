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

    private func checkIfUserIsFollowed(_ notifications: [Notification]) {
        guard !notifications.isEmpty else { return }
        notifications.forEach { notification in
            guard case .follow = notification.type else { return }
            let user = notification.user
            UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
                if let index = self.notifications.firstIndex(where: { $0.user.uid == notification.user.uid }) {
                    self.notifications[index].user.isFollowed = isFollowed
                }
            }
        }
    }

    private func fetchNotifications() {
        refreshControl?.beginRefreshing()
        NotificationService.shared.fetchNotifications { [self] notifications in
            self.notifications = notifications
            checkIfUserIsFollowed(notifications)
            self.refreshControl?.endRefreshing()
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
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }

    private func goToProfileController(user: User) {
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }

    //MARK: - Selectors

    @objc private func handleRefresh() {
        fetchNotifications()
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
        }
    }
}

//MARK: - NotificationCellDelegate

extension NotificationsController: NotificationCellDelegate {

    func didTappedFollow(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else { return }
        if user.isCurrentUser {
            print("DEBUG: Show edit profile controller..")
            return
        }
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { error, reference in
                cell.notification?.user.isFollowed = false
            }
        } else {
            UserService.shared.followUser(uid: user.uid) { error, reference in
                cell.notification?.user.isFollowed = true
                NotificationService.shared.uploadNotification(toUser: user, type: .follow)
            }
        }
    }

    func didTappedProfileImage(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else { return }
        goToProfileController(user: user)
    }
}
