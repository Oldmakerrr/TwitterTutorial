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
    
    private let reuseIdentifier = "FeedControllerCell"
    
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
    
    private func fetchTweets() {
        TweetService.shared.fetchTweets { tweets in
            self.tweets = tweets
        }
    }
    
    //MARK: - Helper Methods
    
    private func configureUI() {
        view.backgroundColor = .white
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        configureNavigationBar()
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
    }
    
    private func goToProfileController(user: User) {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        let tweet = tweets[indexPath.row]
        cell.tweet = tweet
        cell.setProfileImageViewDelegate(self)
        return cell
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
}

//MARK: - ProfileImageViewDelegate

extension FeedController: ProfileImageViewDelegate {
    
    func didTapped(_ view: ProfileImageView, _ user: User?) {
        guard let user = user else { return }
        goToProfileController(user: user)
    }
    
}