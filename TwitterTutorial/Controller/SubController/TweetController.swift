//
//  TweetController.swift
//  TwitterTutorial
//
//  Created by Vladimir Berezin on 30.11.22.
//

import UIKit

class TweetController: UICollectionViewController {

    //MARK: - Properties

    var tweet: Tweet

    var replies = [Tweet]() {
        didSet { collectionView.reloadData() }
    }

    private var actionSheet: ActionSheetLauncher?

    //MARK: - Lifecycle

    init(tweet: Tweet) {
        self.tweet = tweet
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchReplies()
        checkIfUserIsFollowed()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }

    //MARK: - API

    private func checkIfUserLikedTweets(_ tweets: [Tweet]) {
        for (index, tweet) in tweets.enumerated() {
            TweetService.shared.checkIfUserLikedTweet(tweet) { didLike in
                guard didLike == true else { return }
                self.replies[index].didLike = true
            }
        }
    }

    private func checkIfUserIsFollowed() {
        UserService.shared.checkIfUserIsFollowed(uid: tweet.user.uid) { [self] isFollowed in
            tweet.user.isFollowed = isFollowed
            actionSheet = ActionSheetLauncher(user: tweet.user)
            actionSheet?.delegate = self
        }
    }

    private func fetchReplies() {
        TweetService.shared.fetchReplies(forTweet: tweet) { replies in
            self.replies = replies
            self.checkIfUserLikedTweets(replies)
        }
    }

    //MARK: - Helpers

    private func configureCollectionView() {
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TweetHeader.identifier)
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: TweetCell.identifier)
    }

    private func goToUploadReplyController(user: User, tweet: Tweet) {
        let controller = UploadTweetController(user: user, config: .reply(tweet))
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }

    private func goToProfileController(user: User) {
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - UICollectionViewDataSource/Delegate

extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return replies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TweetCell.identifier, for: indexPath) as! TweetCell
        let reply = replies[indexPath.row]
        cell.tweet = reply
        cell.setProfileImageViewDelegate(self)
        cell.delegate = self
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TweetHeader.identifier, for: indexPath) as! TweetHeader
        view.tweet = tweet
        view.setDelegateImageProfile(self)
        view.delegate = self
        return view
    }

}

//MARK: - UICollectionViewDelegateFlowLayout

extension TweetController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweet)
        let height = viewModel.size(forWidth: view.frame.width, withFont: UIFont.systemFont(ofSize: 20)).height
        let viewHeight: CGFloat = viewModel.tweet.isReply ? 240 : 220
        return CGSize(width: view.frame.width - 32, height: height + viewHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = TweetViewModel(tweet: replies[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width, withFont: UIFont.systemFont(ofSize: 14)).height
        return CGSize(width: view.frame.width, height: height + 90)
    }
    
}

//MARK: - StackViewButtonsDelegate

extension TweetController: TweetCellDelegate {

    func didActiveLabel(_ cell: TweetCell, username: String) {

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
            NotificationService.shared.uploadNotification(type: .like, tweet: tweet)
        }
    }

    func didTapShareButton(_ cell: TweetCell) {

    }

}

//MARK: - TweetHeaderDelegate

extension TweetController: TweetHeaderDelegate {

    func didActiveLabel(_ cell: TweetHeader, username: String) {
        UserService.shared.fetchUser(withUsername: username) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    func didTapCommentButton(_ view: TweetHeader) {
        guard let tweet = view.tweet else { return }
        goToUploadReplyController(user: tweet.user, tweet: tweet)
    }

    func didTapRetweetButton(_ view: TweetHeader) {

    }

    func didTapLikeButton(_ view: TweetHeader) {
        guard let tweet = view.tweet else { return }
        TweetService.shared.likeTweet(tweet: tweet) { error, reference in
            if let error = error {
                print("DEBUG: Failed like with error: \(error.localizedDescription)")
            }
            view.tweet?.didLike.toggle()
            let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
            view.tweet?.likes = likes
            guard !tweet.didLike else { return }
            NotificationService.shared.uploadNotification(type: .like, tweet: tweet)
        }
    }

    func didTapShareButton(_ view: TweetHeader) {

    }


    func showActionSheet(_ view: TweetHeader) {
        if tweet.user.isCurrentUser {
            guard let actionSheet = actionSheet else { return }
            actionSheet.show()
        } else {
            UserService.shared.checkIfUserIsFollowed(uid: tweet.user.uid) { [self] isFollowed in
                var user = tweet.user
                user.isFollowed = isFollowed
                actionSheet = ActionSheetLauncher(user: user)
                actionSheet?.delegate = self
                actionSheet?.show()
            }
        }
    }

}

//MARK: - ActionSheetLauncherDelegate

extension TweetController: ActionSheetLauncherDelegate {

    func didSelect(option: ActionSheetOption) {
        switch option {
        case .follow(let user):
            UserService.shared.followUser(uid: user.uid) { error, reference in
                if let error = error {
                    print("DEBUG: Failed follow to \(user.username), with error: \(error.localizedDescription)")
                }
                NotificationService.shared.uploadNotification(type: .follow, user: user)
                print("Did follow user: \(user.username)")
            }
        case .unfollow(let user):
            UserService.shared.unfollowUser(uid: user.uid) { error, reference in
                if let error = error {
                    print("DEBUG: Failed unfollow to \(user.username), with error: \(error.localizedDescription)")
                }
                print("Did unfollow user: \(user.username)")
            }
        case .report:
            showAlert(withMessage: "Your report sending to administrator, thanks for your attention")
        case .delete:
            print("Delete")
        case .blockUser(let user):
            showAlert(withMessage: "User @\(user.username) successfully blocked")
        }
    }

}

//MARK: - ProfileImageViewDelegate

extension TweetController: ProfileImageViewDelegate {

    func didTapped(_ view: ProfileImageView, _ user: User?) {
        guard let user = user else {
            let user = tweet.user
            goToProfileController(user: user)
            return }
        goToProfileController(user: user)
    }

}
