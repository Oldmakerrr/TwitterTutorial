//
//  ProfileFilterCell.swift
//  TwitterTutorial
//
//  Created by Apple on 01.08.2022.
//

import UIKit

class ProfileFilterCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var option: ProfileFilterOptions? {
        didSet { titleLabel.text = option?.description }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.center(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(title: String) {
        titleLabel.text = title
    }
    
    override var isSelected: Bool {
        didSet {
            self.titleLabel.font = self.isSelected ? .boldSystemFont(ofSize: 16) : .systemFont(ofSize: 14)
            self.titleLabel.textColor = self.isSelected ? .twitterBlue : .lightGray
        }
    }
}
