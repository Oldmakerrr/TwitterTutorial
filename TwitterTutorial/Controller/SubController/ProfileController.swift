//
//  ProfileController.swift
//  TwitterTutorial
//
//  Created by Apple on 01.08.2022.
//

import UIKit

class ProfileController: UIViewController {
    
    //MARK: - Properties
    
    var user: User

    private var selectedFilter: ProfileFilterOptions = .tweets {
        didSet {
            collectionView.reloadData()
            updateHeader()
        }
    }

    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let headerView = ProfileHeader()
    private var tweets = [Tweet]()
    private var likedTweets = [Tweet]()
    private var replies = [Tweet]()
    private var currentDataSource: [Tweet] {
        switch selectedFilter {
        case .tweets:
            return tweets
        case .replies:
            return replies
        case .likes:
            return likedTweets
        }
    }
    
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchTweets()
        checkIfUserIsFollowed()
        fetchUserStats()
        fetchLikedTweets()
        fetchReplies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    //MARK: - Selectors



    //MARK: - API

    private func fetchReplies() {
        TweetService.shared.fetchRelies(forUser: user) { replies in
            self.replies = replies
            for (index, reply) in self.replies.enumerated() {
                TweetService.shared.checkIfUserLikedTweet(reply) { didLike in
                    guard didLike == true else { return }
                    self.replies[index].didLike = true
                }
            }
        }
    }

    private func fetchLikedTweets() {
        TweetService.shared.fetchLikedTweets(forUser: user) { [self] likedTweets in
            self.likedTweets = likedTweets
            for (index, tweet) in self.likedTweets.enumerated() {
                TweetService.shared.checkIfUserLikedTweet(tweet) { didLike in
                    guard didLike == true else { return }
                    self.likedTweets[index].didLike = true
                }
            }
        }
    }

    private func checkIfUserLikedTweets(_ tweets: [Tweet]) {
        for (index, tweet) in tweets.enumerated() {
            TweetService.shared.checkIfUserLikedTweet(tweet) { didLike in
                guard didLike == true else { return }
                self.tweets[index].didLike = true
            }
        }
    }
    
    func fetchTweets() {
        TweetService.shared.fetchTweets(forUser: user) { tweets in
            self.tweets = tweets
            self.checkIfUserLikedTweets(tweets)
            self.collectionView.reloadData()
            self.updateHeader()
        }
    }

    func checkIfUserIsFollowed() {
        UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
            self.updateHeader()
        }
    }

    func fetchUserStats() {
        UserService.shared.fetchUserStats(uid: user.uid) { stats in
            self.user.stats = stats
            self.collectionView.reloadData()
            self.updateHeader()
        }
    }
    
    //MARK: - Helper Methods
    
    private func configureUI() {
        configureCollectionView()
        view.addSubview(headerView)
        headerView.delegate = self
        headerView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor)
        view.addSubview(collectionView)
        collectionView.anchor(top: headerView.bottomAnchor,
                              leading: view.leadingAnchor,
                              bottom: view.bottomAnchor,
                              trailing: view.trailingAnchor)
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: TweetCell.identifier)
        collectionView.contentInsetAdjustmentBehavior = .never
        guard let tabHeight = tabBarController?.tabBar.frame.height else { return }
        collectionView.contentInset.bottom = tabHeight
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }

    private func goToUploadReplyController(user: User, tweet: Tweet) {
        let controller = UploadTweetController(user: user, config: .reply(tweet))
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }

    private func updateHeader() {
        headerView.setupUser(user)
    }
    
}

//MARK: - UICollectionViewDataSource/Delegate

extension ProfileController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TweetCell.identifier, for: indexPath) as! TweetCell
        cell.delegate = self
        let tweet = currentDataSource[indexPath.row]
        cell.tweet = tweet
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tweet = currentDataSource[indexPath.row]
        let controller = TweetController(tweet: tweet)
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = TweetViewModel(tweet: currentDataSource[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width, withFont: UIFont.systemFont(ofSize: 14)).height
        let cellHeight: CGFloat = viewModel.tweet.isReply ? 92 : 72
        return CGSize(width: view.frame.width, height: height + cellHeight)
    }
    
}

//MARK: - ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate {

    func didChangeFilterOptoin(_ view: ProfileHeader, selectedFilter: ProfileFilterOptions) {
        self.selectedFilter = selectedFilter
    }

    func handleEditProfileFollow(_ view: ProfileHeader) {

        if user.isCurrentUser {
            let controller = EditProfileController(user: user)
            controller.delegate = self
            let navigation = UINavigationController(rootViewController: controller)
            navigation.modalPresentationStyle = .fullScreen
            present(navigation, animated: true)
            return
        }

        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { error, reference in
                self.user.isFollowed = false
                self.collectionView.reloadData()
                self.updateHeader()
            }
        } else {
            UserService.shared.followUser(uid: self.user.uid) { error, reference in
                self.user.isFollowed = true 
                self.collectionView.reloadData()
                self.updateHeader()
                NotificationService.shared.uploadNotification(toUser: self.user, type: .follow)
            }
        }
    }
    
    func didTappedBack(_ view: ProfileHeader) {
        navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - TweetCellDelegate

extension ProfileController: TweetCellDelegate {
    
    func didActiveLabel(_ cell: TweetCell, username: String) {
        UserService.shared.fetchUser(withUsername: username) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    func didTapCommentButton(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        goToUploadReplyController(user: tweet.user, tweet: tweet)
    }

    func didTapRetweetButton(_ cell: TweetCell) {

    }

    func didTapLikeButton(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        TweetService.shared.likeTweet(tweet: tweet) { error, reference in
            if let error = error {
                print("DEBUG: Failed like with error: \(error.localizedDescription)")
            }
            cell.tweet?.didLike.toggle()
            let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
            cell.tweet?.likes = likes
            guard !tweet.didLike else { return }
            NotificationService.shared.uploadNotification(toUser: tweet.user, type: .like, tweetId: tweet.tweetId)
        }

    }

    func didTapShareButton(_ cell: TweetCell) {

    }

}

//MARK: - EditProfileControllerDelegate

extension ProfileController: EditProfileControllerDelegate {

    func controller(_ controller: EditProfileController, wantsToUpdate user: User) {
        controller.dismiss(animated: true)
        self.user = user
        collectionView.reloadData()
        self.updateHeader()
    }

}
