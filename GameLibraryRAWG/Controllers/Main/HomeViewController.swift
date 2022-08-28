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
    case upcoming = 2
    case test = 3
}

class HomeViewController: UIViewController {
    
    private var games = [Game]()
    private var mustPlay = [Game]()
    private var recent = [Game]()
    private var test = [Game]()
    
    private let sectionTitles = ["Metacritic's choice", "Popular This Year", "Most Anticipated Upcoming Games", "Test"]
    
    private let collectionView: UICollectionView = {
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
        fetchUpcomingGames()
        fetchTestGames()
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
    
    private func fetchUpcomingGames() {
        APICaller.shared.fetchUpcomingGames { [weak self] result in
            switch result {
            case .success(let games):
                DispatchQueue.main.async {
                    self?.recent = games
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchTestGames() {
        APICaller.shared.fetchUpcomingGames { [weak self] result in
            switch result {
            case .success(let games):
                DispatchQueue.main.async {
                    self?.test = games
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
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as! HeaderCollectionReusableView
        
        header.configure(with: sectionTitles[indexPath.section])
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Sections(rawValue: section) {
        case .mustPlay:
            return mustPlay.count
        case .popular:
            return games.count
        case .upcoming:
            return recent.count
        case .test:
            return test.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCollectionViewCell.identifier, for: indexPath) as? GameCollectionViewCell else { return UICollectionViewCell() }
        
        switch Sections(rawValue: indexPath.section) {
        case .mustPlay:
            cell.configure(with: mustPlay[indexPath.item])
        case .popular:
            cell.configure(with: games[indexPath.item])
        case .upcoming:
            cell.configure(with: recent[indexPath.item])
        case .test:
            cell.configure(with: test[indexPath.item])
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
                return .regularSection()
            case .upcoming:
                return .mostUpcomingGames()
            case .test:
                return .testGames()
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
        item.contentInsets.leading = 15
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(300), heightDimension: .absolute(200))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .continuous
        
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        
        section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)]
        
        return section
    }
    
    //Second section layout setup
    static func regularSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets.trailing = 15
        item.contentInsets.leading = 15
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.2))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .continuous
        
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80))
        
        section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)]
        
        return section
    }
    
    //Third section layout setup
    static func mostUpcomingGames() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .paging
        
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80))
        
        section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)]
        
        return section
    }
    
    //Four section layout setup
    static func testGames() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.4))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets.trailing = 10
        item.contentInsets.top = 10

        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.leading = 20
        section.contentInsets.trailing = -20
        
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80))
        
        section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)]
        
        return section
    }
}
