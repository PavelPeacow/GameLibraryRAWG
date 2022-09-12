//
//  SearchViewController.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 25.08.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    //MARK: PROPERTIES
    private var games = [Game]()
    private var page = 1
    
    //MARK: VIEWS
    private let searchTable: UITableView = {
        let searchTable = UITableView(frame: .zero, style: .plain)
        searchTable.register(SearchGameTableViewCell.self, forCellReuseIdentifier: SearchGameTableViewCell.identifier)
        return searchTable
    }()
    
    private let seacrhController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        return searchController
    }()
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(searchTable)
        
        setDelegates()
        fetchGames(with: page)
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
    
    private func fetchGames(with page: Int) {
        loadingIndicator()
        APICaller.shared.fetchGamesWithPage(url: APIConstants.DISCOVER_URL, expecting: GamesResponse.self, pageNumber: page) { [weak self] result in
            self?.removeLoadingIndicatior()
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.games += response.results
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

//MARK: TableView settings
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchGameTableViewCell.identifier, for: indexPath) as! SearchGameTableViewCell
        
        cell.configure(with: games[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        loadingIndicator()
        tableView.deselectRow(at: indexPath, animated: true)
        
        APICaller.shared.fetchMainGameDetails(with: games[indexPath.row].slug) { [weak self] result in
            
            self?.removeLoadingIndicatior()
            
            switch result {
            case .success(let gameDetails):
                DispatchQueue.main.async {
                    let vc = GameDetailViewController()
                    vc.configure(with: gameDetails, game: self!.games[indexPath.row])
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
       
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        print("offset = \(offsetY)")
        print("contentHeight = \(contentHeight)")
        print("height = \(height)")
        
        if offsetY > contentHeight - height {
            page += 1
            fetchGames(with: page)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
}

//MARK: UISeacrh
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
