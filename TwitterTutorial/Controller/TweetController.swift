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

    //MARK: - API

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
        cell.delegate = self
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TweetHeader.identifier, for: indexPath) as! TweetHeader
        view.tweet = tweet
        view.delegate = self
        return view
    }

}

//MARK: - UICollectionViewDelegateFlowLayout

extension TweetController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweet)
        let height = viewModel.size(forWidth: view.frame.width, withFont: UIFont.systemFont(ofSize: 20)).height
        return CGSize(width: view.frame.width - 32, height: height + 220)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
}

//MARK: - StackViewButtonsDelegate

extension TweetController: TweetCellDelegate {

    func didTapCommentButton(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        goToUploadReplyController(user: tweet.user, tweet: tweet)
    }

    func didTapRetweetButton(_ cell: TweetCell) {

    }

    func didTapLikeButton(_ cell: TweetCell) {

    }

    func didTapShareButton(_ cell: TweetCell) {

    }

}

//MARK: - TweetHeaderDelegate

extension TweetController: TweetHeaderDelegate {

    func didTapCommentButton(_ view: TweetHeader) {
        guard let tweet = view.tweet else { return }
        goToUploadReplyController(user: tweet.user, tweet: tweet)
    }

    func didTapRetweetButton(_ view: TweetHeader) {

    }

    func didTapLikeButton(_ view: TweetHeader) {

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
