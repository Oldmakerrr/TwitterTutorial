//
//  ExploreController.swift
//  TwitterTutorial
//
//  Created by Apple on 15.07.2022.
//

import UIKit

class ExploreController: UITableViewController {
    
    //MARK: - Properties
    
    let reuseIdentifier = "ExploreControllerCell"
    
    private var users = [User]() {
        didSet { tableView.reloadData() }
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
        configureUI()
    }
    
    //MARK: - API
    
    func fetchUsers() {
        UserService.shared.fetchUsers { users in
            self.users = users
        }
    }
    
    //MARK: - Helper Methods
    
    private func configureUI() {
        configureTableView()
        view.backgroundColor = .white
        navigationItem.title = "Explore"

    }
    
    private func configureTableView() {
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
    }
    
}

//MARK: - UITableViewDataSource

extension ExploreController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.setUser(user)
        return cell
    }
    
}
