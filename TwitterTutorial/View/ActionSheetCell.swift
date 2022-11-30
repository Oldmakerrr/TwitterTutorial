//
//  ActionSheetCell.swift
//  TwitterTutorial
//
//  Created by Vladimir Berezin on 30.11.22.
//

import UIKit

class ActionSheetCell: UITableViewCell, ReusableView {

    //MARK: - Properties

    var option: ActionSheetOption? {
        didSet { populateUI() }
    }

    static var identifier: String {
        String(describing: self)
    }

    private let optionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "twitter_logo_blue")
        return imageView
    }()

    private let titleLabel = UILabel()

    //MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Helpers

    private func configureUI() {
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        addSubview(optionImageView)
        optionImageView.centerY(inView: self)
        optionImageView.anchor(leading: leadingAnchor, paddingLeading: 8)
        optionImageView.setDimensions(width: 36, height: 36)
        addSubview(titleLabel)
        titleLabel.centerY(inView: self)
        titleLabel.anchor(leading: optionImageView.trailingAnchor, paddingLeading: 12)
    }

    private func populateUI() {
        titleLabel.text = option?.description
    }
}
