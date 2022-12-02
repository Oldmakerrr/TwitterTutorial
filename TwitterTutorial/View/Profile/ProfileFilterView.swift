//
//  ProfileFilterView.swift
//  TwitterTutorial
//
//  Created by Apple on 01.08.2022.
//

import UIKit

protocol ProfileFilterViewDelegate: AnyObject {
    func didSelect(_ view: ProfileFilterView, selectedFilter: ProfileFilterOptions)
}

class ProfileFilterView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: ProfileFilterViewDelegate?

    private let underlineView = UIView()
    
    private let reuseIdentifier = "ProfileFilterViewCell"
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
        collectionView.register(ProfileFilterCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .left)
        underlineView.backgroundColor = .twitterBlue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        addSubview(underlineView)
        let numberOfItem = CGFloat(ProfileFilterOptions.allCases.count)
        underlineView.anchor(leading: leadingAnchor, bottom: bottomAnchor,
                             width: frame.width / numberOfItem, height: 2)
    }
}

//MARK: - UICollectionViewDataSource

extension ProfileFilterView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileFilterOptions.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileFilterCell
        let option = ProfileFilterOptions(rawValue: indexPath.row)
        cell.option = option
        return cell
    }
    
}

//MARK: - UICollectionViewDelegate

extension ProfileFilterView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ProfileFilterCell,
              let selectedFilter = ProfileFilterOptions(rawValue: indexPath.row) else { return }
        let xPosition = cell.frame.origin.x
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = xPosition

        } completion: { _ in
            self.delegate?.didSelect(self, selectedFilter: selectedFilter)
        }
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ProfileFilterView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItem = CGFloat(ProfileFilterOptions.allCases.count)
        return CGSize(width: frame.width / numberOfItem, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
