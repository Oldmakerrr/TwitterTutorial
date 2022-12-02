//
//  ProfileController.swift
//  TwitterTutorial
//
//  Created by Apple on 01.08.2022.
//

import UIKit

class ProfileController: UICollectionViewController {
    
    //MARK: - Properties
    
    var user: User

    private var selectedFilter: ProfileFilterOptions = .tweets {
        didSet { collectionView.reloadData() }
    }
    
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
    
    init(user: User, layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()) {
        self.user = user
        super.init(collectionViewLayout: layout)
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
        }
    }

    func checkIfUserIsFollowed() {
        UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }

    func fetchUserStats() {
        UserService.shared.fetchUserStats(uid: user.uid) { stats in
            self.user.stats = stats
            self.collectionView.reloadData()
        }
    }
    
    //MARK: - Helper Methods
    
    private func configureUI() {
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: TweetCell.identifier)
        collectionView.register(ProfileHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: ProfileHeader.identifier)
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
    
}

//MARK: - UICollectionViewDataSource/Delegate

extension ProfileController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentDataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TweetCell.identifier, for: indexPath) as! TweetCell
        cell.delegate = self
        let tweet = currentDataSource[indexPath.row]
        cell.tweet = tweet
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileHeader.identifier, for: indexPath) as! ProfileHeader
        view.setupUser(user)
        view.delegate = self
        return view
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tweet = currentDataSource[indexPath.row]
        let controller = TweetController(tweet: tweet)
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 370)
    }
    
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
            let navigation = UINavigationController(rootViewController: controller)
            navigation.modalPresentationStyle = .fullScreen
            present(navigation, animated: true)
            return
        }

        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { error, reference in
                self.user.isFollowed = false
                self.collectionView.reloadData()
            }
        } else {
            UserService.shared.followUser(uid: self.user.uid) { error, reference in
                self.user.isFollowed = true 
                self.collectionView.reloadData()
                NotificationService.shared.uploadNotification(type: .follow, user: self.user)
            }
        }
    }
    
    func didTappedBack(_ view: ProfileHeader) {
        navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - TweetCellDelegate

extension ProfileController: TweetCellDelegate {

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
            NotificationService.shared.uploadNotification(type: .like, tweet: tweet)
        }

    }

    func didTapShareButton(_ cell: TweetCell) {

    }

}
