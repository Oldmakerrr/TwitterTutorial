//
//  EditProfileCell.swift
//  TwitterTutorial
//
//  Created by Vladimir Berezin on 02.12.22.
//

import UIKit

class EditProfileCell: UITableViewCell, ReusableView {

    //MARK: - Properties

    var viewModel: EditProfileViewModel? {
        didSet { updateUI() }
    }

    static var identifier: String {
        String(describing: self)
    }

    let titleLabel = UILabel()

    let infoTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textAlignment = .left
        textField.textColor = .twitterBlue
        return textField
    }()

    let bioTextLabel: InputTextView = {
        let textField = InputTextView()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = .twitterBlue
        textField.placeholderLabel.textColor = .systemGray4
        return textField
    }()

    //MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        addTargets()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Selectors

    @objc private func handleUpdateUserInfo() {

    }

    //MARK: - Helpers

    private func configureUI() {
        selectionStyle = .none
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        addSubview(titleLabel)
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, paddingTop: 12, paddingLeading: 16)
        contentView.addSubview(infoTextField)
        infoTextField.anchor(top: topAnchor, leading: titleLabel.trailingAnchor, trailing: trailingAnchor,
                             paddingTop: 10, paddingLeading: 16, paddingTrailing: 8)

        contentView.addSubview(bioTextLabel)
        bioTextLabel.anchor(top: topAnchor, leading: titleLabel.trailingAnchor, trailing: trailingAnchor,
                             paddingTop: 2, paddingLeading: 12, paddingTrailing: 8)
    }

    private func addTargets() {
        infoTextField.addTarget(self, action: #selector(handleUpdateUserInfo), for: .editingDidEnd)
    }

    private func updateUI() {
        guard let viewModel = viewModel else { return }
        infoTextField.isHidden = viewModel.shouldHideTextField
        bioTextLabel.isHidden = viewModel.shuldHideTextView
        titleLabel.text = viewModel.titleText
        infoTextField.text = viewModel.optionValue
        bioTextLabel.text = viewModel.optionValue
        infoTextField.placeholder = viewModel.placeholder
        bioTextLabel.placeholderLabel.text = viewModel.placeholder
    }

}
