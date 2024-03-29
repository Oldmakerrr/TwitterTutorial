//
//  FeedController.swift
//  TwitterTutorial
//
//  Created by Apple on 15.07.2022.
//

import UIKit
import SDWebImage

class FeedController: UICollectionViewController {
    
    //MARK: - Properties
    
    private var tweets = [Tweet]() {
        didSet { collectionView.reloadData() }
    }
    
    var user: User? {
        didSet {
            configureProfileImage()
        }
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchTweets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - API
    
    fileprivate func checkIfUserLikedTweets(_ tweets: [Tweet]) {
        tweets.forEach { tweet in
            TweetService.shared.checkIfUserLikedTweet(tweet) { didLike in
                guard didLike == true else { return }
                if let index = tweets.firstIndex(where: { $0.tweetId == tweet.tweetId}) {
                    self.tweets[index].didLike = true
                }
            }
        }
    }

    private func fetchTweets() {
        collectionView.refreshControl?.beginRefreshing()
        TweetService.shared.fetchTweets { [self] tweets in
            self.tweets = tweets.sorted(by: { $0.timestamp > $1.timestamp })
            checkIfUserLikedTweets(self.tweets)
            collectionView.refreshControl?.endRefreshing()
        }
    }
    
    //MARK: - Helper Methods
    
    private func configureUI() {
        view.backgroundColor = .white
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: TweetCell.identifier)
        configureNavigationBar()
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    private func configureNavigationBar() {
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = imageView
    }
    
    private func configureProfileImage() {
        guard let user = user else { return }
        let profileImageView = UIImageView()
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.sd_setImage(with: user.profileImageUrl)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTap))
        profileImageView.addGestureRecognizer(tap)
        profileImageView.isUserInteractionEnabled = true
    }
    
    private func goToProfileController(user: User) {
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }

    private func goToUploadReplyController(user: User, tweet: Tweet) {
        let controller = UploadTweetController(user: user, config: .reply(tweet))
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }

    //MARK: - Selectors

    @objc private func handleRefresh() {
        fetchTweets()
    }

    @objc private func handleProfileImageTap() {
        guard let user = user else { return }
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - UICollectionViewDataSource/Delegate

extension FeedController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TweetCell.identifier, for: indexPath) as! TweetCell
        let tweet = tweets[indexPath.row]
        cell.tweet = tweet
        cell.setProfileImageViewDelegate(self)
        cell.delegate = self
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tweet = tweets[indexPath.row]
        let controller = TweetController(tweet: tweet)
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweets[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width - 32, withFont: UIFont.systemFont(ofSize: 14)).height
        return CGSize(width: view.frame.width, height: height + 70)
    }
    
}

//MARK: - ProfileImageViewDelegate

extension FeedController: ProfileImageViewDelegate {
    
    func didTapped(_ view: ProfileImageView, _ user: User?) {
        guard let user = user else { return }
        goToProfileController(user: user)
    }
    
}

//MARK: - TweetCellDelegate

extension FeedController: TweetCellDelegate {
    
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
            NotificationService.shared.uploadNotification(toUser: tweet.user,
                                                          type: .like,
                                                          tweetId: tweet.tweetId)
        }
    }

    func didTapShareButton(_ cell: TweetCell) {

    }


}
