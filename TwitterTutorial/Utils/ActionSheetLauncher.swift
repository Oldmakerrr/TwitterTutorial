//
//  ActionSheetLauncher.swift
//  TwitterTutorial
//
//  Created by Vladimir Berezin on 30.11.22.
//

import UIKit

class ActionSheetLauncher: NSObject {

    //MARK: - Properties

    private let identifier = "ActionSheetLauncherCellCell"
    private let user: User
    private let tableView = UITableView()
    private var window: UIWindow?

    private let blackView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismisal))
        view.addGestureRecognizer(tap)
        return view
    }()

    //MARK: Lifecycle

    init(user: User) {
        self.user = user
        super.init()
        configureTableView()
    }

    //MARK: - Selectors

    @objc private func handleDismisal() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.tableView.frame.origin.y += 300
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
                                 width: window.frame.width, height: 300)
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
            self.tableView.frame.origin.y -= 300
        }
        
    }

    private func configureTableView() {
        tableView.backgroundColor = .red
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5
        tableView.isScrollEnabled = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
    }
}

//MARK: - UITableViewDataSource/Delegate

extension ActionSheetLauncher: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        return cell
    }


}
