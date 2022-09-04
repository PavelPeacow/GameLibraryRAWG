//
//  SearchViewController.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 25.08.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var games = [Game]()
    
    private let searchTable: UITableView = {
        let searchTable = UITableView(frame: .zero, style: .grouped)
        searchTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return searchTable
    }()
    
    private let seacrhController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(searchTable)
        
        setDelegates()
        fetchGames()
        configureNavBar()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTable.frame = view.bounds
    }
    
    private func setDelegates() {
        searchTable.delegate = self
        searchTable.dataSource = self
        
        seacrhController.searchResultsUpdater = self
    }
    
    private func fetchGames() {
        APICaller.shared.fetchGames(url: APIConstants.DISCOVER_URL, expecting: GamesResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.games = response.results
                    self?.searchTable.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configureNavBar() {
        navigationItem.searchController = seacrhController
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = games[indexPath.row].name
        
        return cell
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text else { return }
        
        APICaller.shared.searchGames(with: query) { [weak self] result in
            switch result {
            case .success(let games):
                DispatchQueue.main.async {
                    self?.games = games
                    self?.searchTable.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
