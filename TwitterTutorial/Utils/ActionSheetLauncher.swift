//
//  ActionSheetLauncher.swift
//  TwitterTutorial
//
//  Created by Vladimir Berezin on 30.11.22.
//

import UIKit

class ActionSheetLauncher: NSObject {

    //MARK: - Properties

    private let viewModel: ActionSheetViewModel
    var animateDuration: TimeInterval = 0.3
    private let padding: CGFloat = 20
    private let footerHeight: CGFloat = 60
    private let rowHeight: CGFloat = 60
    private var height: CGFloat {
        CGFloat(viewModel.options.count) * rowHeight + footerHeight + padding
    }
    private let user: User
    private let tableView = UITableView()
    private var window: UIWindow?

    private let blackView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()

    private lazy var footerView: UIView = {
        let view = UIView()
        let height: CGFloat = 50
        let padding: CGFloat = 12
        view.addSubview(cancelButton)
        cancelButton.heightAnchor.constraint(equalToConstant: height).isActive = true
        cancelButton.anchor(leading: view.leadingAnchor, trailing: view.trailingAnchor,
                            paddingLeading: padding, paddingTrailing: padding)
        cancelButton.centerY(inView: view)
        cancelButton.layer.cornerRadius = height / 2
        return view
    }()

    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGroupedBackground
        return button
    }()

    //MARK: Lifecycle

    init(user: User) {
        self.user = user
        viewModel = ActionSheetViewModel(user: user)
        super.init()
        configureTableView()
        configureTargets()
    }

    //MARK: - Selectors

    @objc private func handleDismisal() {
        UIView.animate(withDuration: animateDuration) { [self] in
            blackView.alpha = 0
            tableView.frame.origin.y += height
        }
    }

    //MARK: - Helper

    func show() {
        guard let window = UIApplication.shared.connectedScenes.compactMap({ ($0 as? UIWindowScene)?.keyWindow }).first else { return }
        self.window = window
        window.addSubview(blackView)
        blackView.frame = window.frame

        window.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: window.frame.height,
                                 width: window.frame.width, height: height)
        UIView.animate(withDuration: animateDuration) { [self] in
            blackView.alpha = 1
            tableView.frame.origin.y -= height
        }
        
    }

    private func configureTargets() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismisal))
        tap.numberOfTapsRequired = 1
        blackView.addGestureRecognizer(tap)
        cancelButton.addTarget(self, action: #selector(handleDismisal), for: .touchUpInside)
    }

    private func configureTableView() {
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = rowHeight
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5
        tableView.isScrollEnabled = false
        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: ActionSheetCell.identifier)
    }
}

//MARK: - UITableViewDataSource/Delegate

extension ActionSheetLauncher: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ActionSheetCell.identifier, for: indexPath) as! ActionSheetCell
        cell.option = viewModel.options[indexPath.row]
        return cell
    }

}

extension ActionSheetLauncher: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerHeight
    }
}
