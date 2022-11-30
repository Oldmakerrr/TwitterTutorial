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
    }

    private func configureCollectionView() {
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TweetHeader.identifier)
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: TweetCell.identifier)
    }

}

//MARK: - UICollectionViewDataSource/Delegate

extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TweetCell.identifier, for: indexPath) as! TweetCell

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
        return CGSize(width: view.frame.width, height: 240)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
}

extension TweetController: StackViewButtonsDelegate {

    func didTapCommentButton(_ view: StackViewButtons) {

    }

    func didTapRetweetButton(_ view: StackViewButtons) {

    }

    func didTapLikeButton(_ view: StackViewButtons) {

    }

    func didTapShareButton(_ view: StackViewButtons) {

    }

}
