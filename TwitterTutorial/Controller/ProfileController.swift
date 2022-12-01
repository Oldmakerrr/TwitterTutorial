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
    
    private var tweets = [Tweet]() {
        didSet { collectionView.reloadData() }
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    //MARK: - Selectors
    
    //MARK: - API

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
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TweetCell.identifier, for: indexPath) as! TweetCell
        cell.delegate = self
        let tweet = tweets[indexPath.row]
        cell.tweet = tweet
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileHeader.identifier, for: indexPath) as! ProfileHeader
        view.setupUser(user)
        view.delegate = self
        return view
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 370)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweets[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width, withFont: UIFont.systemFont(ofSize: 14)).height
        return CGSize(width: view.frame.width, height: height + 120)
    }
    
}

//MARK: - ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate {

    func handleEditProfileFollow(_ view: ProfileHeader) {

        if user.isCurrentUser {
            print("DEBUG: Show edit profile controller..")
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
