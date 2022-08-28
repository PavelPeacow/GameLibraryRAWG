//
//  HomeViewController.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 25.08.2022.
//

import UIKit

enum Sections: Int {
    case mustPlay = 0
    case popular = 1
}

class HomeViewController: UIViewController {
    
    private var games = [Game]()
    private var mustPlay = [Game]()
    
    private let sectionTitles = ["Metacritic's choice", "Popular This Year"]
    
    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout.createLayout())
        collectionView.register(GameCollectionViewCell.self, forCellWithReuseIdentifier: GameCollectionViewCell.identifier)
        
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        setDelegates()
        
        fetchGames()
        fetchMustPlayGames()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func fetchGames() {
        APICaller.shared.fetchPopularGames { [weak self] result in
            switch result {
            case .success(let games):
                DispatchQueue.main.async {
                    self?.games = games
                    self?.collectionView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchMustPlayGames() {
        APICaller.shared.fetchMustPlayGames { [weak self] result in
            switch result {
            case .success(let games):
                DispatchQueue.main.async {
                    self?.mustPlay = games
                    self?.collectionView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}


//MARK: CollectionView settings
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as! HeaderCollectionReusableView
        
        header.configure(with: sectionTitles[indexPath.section])
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case Sections.mustPlay.rawValue:
            return mustPlay.count
        case Sections.popular.rawValue:
            return games.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCollectionViewCell.identifier, for: indexPath) as? GameCollectionViewCell else { return UICollectionViewCell() }
        
        switch indexPath.section {
        case Sections.mustPlay.rawValue:
            cell.configure(with: mustPlay[indexPath.item])
        case Sections.popular.rawValue:
            cell.configure(with: games[indexPath.item])
        default:
            cell.configure(with: games.first!)
        }
    
        return cell
    }
    
}


//MARK: CollectionView layout
extension UICollectionViewCompositionalLayout {
    //Create whole layout for collectionView
    static func createLayout() -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout { sectionIndex, env in
            
            switch Sections(rawValue: sectionIndex) {
            case .mustPlay:
                return .mustPlaySection()
            case .popular:
                return .popularThisYearSection()
            default:
                return .none
            }
        }
    }
}


extension NSCollectionLayoutSection {
    
    //First section layout setup
    static func mustPlaySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets.trailing = 15
        
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(300), heightDimension: .absolute(200))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .continuous
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        
        section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)]
        
        return section
    }
    
    //Second section layout setup
    static func popularThisYearSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.5))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets.trailing = 15
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .fractionalHeight(0.5))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .continuous
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80))
        
        section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)]
        
        return section
    }
}
