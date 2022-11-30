//
//  TweetController.swift
//  TwitterTutorial
//
//  Created by Vladimir Berezin on 30.11.22.
//

import UIKit

class TweetController: UICollectionViewController {

    //MARK: - Properties

    let tweet: Tweet

    var replies = [Tweet]() {
        didSet { collectionView.reloadData() }
    }

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
    }

    //MARK: - API

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
        cell.setStackViewButtonDelegate(self)
        cell.tweet = reply
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TweetHeader.identifier, for: indexPath) as! TweetHeader
        view.tweet = tweet
        view.setDelegateToStackViewButtons(self)
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

extension TweetController: StackViewButtonsDelegate {

    func didTapCommentButton(_ view: StackViewButtons) {
        guard let tweet = view.tweet else { return }
        goToUploadReplyController(user: tweet.user, tweet: tweet)
    }

    func didTapRetweetButton(_ view: StackViewButtons) {

    }

    func didTapLikeButton(_ view: StackViewButtons) {

    }

    func didTapShareButton(_ view: StackViewButtons) {

    }

}
