//
//  HomeViewController.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 25.08.2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var games = [Game]()
    
    private var collectionView: UITableView = {
        let collectionView = UITableView(frame: .zero, style: .grouped)
        collectionView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        setDelegates()
        
        view.backgroundColor = .systemBackground
        
        APICaller.shared.fetchGames { [weak self] result in
            
                switch result {
                case .success(let games):
                    DispatchQueue.main.async {
                        self?.games = games
                        self?.collectionView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = collectionView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = games[indexPath.row].name
        return cell
    }
    

    
    
}
