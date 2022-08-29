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
    case discover = 3
}

class HomeViewController: UIViewController {
    
    private var mustPlay = [Game]()
    private var popular = [Game]()
    private var upcoming = [Game]()
    private var discover = [Game]()
    
    private let sectionTitles = ["Metacritic's choice", "Popular This Year", "Most Anticipated Upcoming Games", "More games to discover"]
    
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
        
        fetchPopularGames()
        fetchMustPlayGames()
        fetchUpcomingGames()
        fetchDiscoverMoreGames()
        
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

//MARK: API Results
extension HomeViewController {
    
    func fetchMustPlayGames() {
        APICaller.shared.fetch(url: APIConstants.METACRITIC_URL, expecting: GamesResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.mustPlay = response.results
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchPopularGames() {
        APICaller.shared.fetch(url: APIConstants.POPULAR_URL, expecting: GamesResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.popular = response.results
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchUpcomingGames() {
        APICaller.shared.fetch(url: APIConstants.UPCOMING_URL, expecting: GamesResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.upcoming = response.results
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchDiscoverMoreGames() {
        APICaller.shared.fetch(url: APIConstants.DISCOVER_URL, expecting: GamesResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.discover = response.results
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
    
    //MARK: Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as! HeaderCollectionReusableView
        
        header.configure(with: sectionTitles[indexPath.section])
        
        return header
    }
    
    //MARK: Number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Sections(rawValue: section) {
        case .mustPlay:
            return mustPlay.count
        case .popular:
            return popular.count
        case .upcoming:
            return upcoming.count
        case .discover:
            return discover.count
        default:
            return 0
        }
    }
    
    //MARK: Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCollectionViewCell.identifier, for: indexPath) as? GameCollectionViewCell else { return UICollectionViewCell() }
        
        switch Sections(rawValue: indexPath.section) {
        case .mustPlay:
            cell.configure(with: mustPlay[indexPath.item])
        case .popular:
            cell.configure(with: popular[indexPath.item])
        case .upcoming:
            cell.configure(with: upcoming[indexPath.item])
        case .discover:
            cell.configure(with: discover[indexPath.item])
        default:
            fatalError("why cell is not setup?")
        }
        
        return cell
    }
    
    //MARK: DID Select
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = GameDetailViewController()
        
        switch Sections(rawValue: indexPath.section) {
        case .mustPlay:
            APICaller.shared.fetchGameDetails(with: mustPlay[indexPath.item].slug) { [weak self]result in
                switch result {
                case .success(let gameDetail):
                    DispatchQueue.main.async {
                        vc.configure(with: gameDetail)
                        self?.navigationController?.pushViewController(vc, animated: true)
                        print(gameDetail)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        case .popular:
            APICaller.shared.fetchGameDetails(with: popular[indexPath.item].slug) { [weak self]result in
                switch result {
                case .success(let gameDetail):
                    DispatchQueue.main.async {
                        vc.configure(with: gameDetail)
                        self?.navigationController?.pushViewController(vc, animated: true)
                        print(gameDetail)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        case .upcoming:
            APICaller.shared.fetchGameDetails(with: upcoming[indexPath.item].slug) { [weak self]result in
                switch result {
                case .success(let gameDetail):
                    DispatchQueue.main.async {
                        vc.configure(with: gameDetail)
                        self?.navigationController?.pushViewController(vc, animated: true)
                        print(gameDetail)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        case .discover:
            APICaller.shared.fetchGameDetails(with: discover[indexPath.item].slug) { [weak self]result in
                switch result {
                case .success(let gameDetail):
                    DispatchQueue.main.async {
                        vc.configure(with: gameDetail)
                        self?.navigationController?.pushViewController(vc, animated: true)
                        print(gameDetail)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        default:
            fatalError("why touching don't work?")
        }
        
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
            case .discover:
                return .discoverGames()
            default:
                fatalError("why there more section than needed?")
            }
        }
    }
}


extension NSCollectionLayoutSection {
    
    //First section layout setup
    static func mustPlaySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(300), heightDimension: .absolute(200))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.trailing = 15
        section.contentInsets.leading = 15
        section.interGroupSpacing = 15
        
        section.orthogonalScrollingBehavior = .continuous
        
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80))
        
        section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)]
        
        return section
    }
    
    //Second section layout setup
    static func regularSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.2))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.trailing = 15
        section.contentInsets.leading = 15
        section.interGroupSpacing = 15
        
        section.orthogonalScrollingBehavior = .continuous
        
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80))
        
        section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)]
        
        return section
    }
    
    //Third section layout setup
    static func mostUpcomingGames() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .fractionalHeight(0.55))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets.leading = 15
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
        
        section.orthogonalScrollingBehavior = .groupPaging
        
        
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80))
        
        section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)]
        
        return section
    }
    
    //Four section layout setup
    static func discoverGames() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.4))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets.trailing = 10
        item.contentInsets.bottom = 10
        
        
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
