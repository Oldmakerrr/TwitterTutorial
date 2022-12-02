//
//  SearchController.swift
//  TwitterTutorial
//
//  Created by Apple on 15.07.2022.
//

import UIKit

enum SearchControllerConfiguration {
    case messages
    case userSearch
}

class SearchController: UITableViewController {
    
    //MARK: - Properties
    
    private var config: SearchControllerConfiguration
    
    private var users = [User]() {
        didSet { tableView.reloadData() }
    }

    private let searchController = UISearchController(searchResultsController: nil)

    private var filteredUsers = [User]() {
        didSet { tableView.reloadData() }
    }

    private var isSearchMode: Bool {
        guard let searchedText = searchController.searchBar.text else { return false }
        return searchController.isActive && !searchedText.isEmpty
    }
    
    //MARK: - Lifecycle

    init(config: SearchControllerConfiguration) {
        self.config = config
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
        configureUI()
        configureSearchController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
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
        navigationItem.title = config == .messages ? "New Message" : "Explore"
        if config == .messages {
            let barButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                            target: self,
                                            action: #selector(handleDismissal))
            navigationItem.leftBarButtonItem = barButton
        }
    }

    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search fo user"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    
    private func configureTableView() {
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.identifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
    }

    //MARK: - Selectors

    @objc private func handleDismissal() {
        dismiss(animated: true)
    }
    
}

//MARK: - UITableViewDataSource

extension SearchController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.identifier, for: indexPath) as! UserCell
        let user = isSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.setUser(user)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = isSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension SearchController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filteredUsers = users.filter { $0.username.contains(searchText) }
    }

}
