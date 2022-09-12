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
    
    //MARK: PROPERTIES
    private var mustPlay = [Game]()
    private var popular = [Game]()
    private var upcoming = [Game]()
    private var discover = [Game]()
    
    private var page = 1
    
    private let sectionTitles = ["Metacritic's choice", "Popular This Year", "Most Anticipated Upcoming Games", "More games to discover"]
    
    //MARK: VIEWS
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout.createLayout())
        collectionView.register(GameCollectionViewCell.self, forCellWithReuseIdentifier: GameCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier)
        return collectionView
    }()
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureNavBar()
        
        view.addSubview(collectionView)
        setDelegates()
        
        fetchPopularGames()
        fetchMustPlayGames()
        fetchUpcomingGames()
        fetchDiscoverMoreGames(with: page)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //prevent double tapping, it causing pushViewController appear twice
        view.isUserInteractionEnabled = true
    }
    
    private func configureNavBar() {
        title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}

//MARK: API Results
extension HomeViewController {
    
    func fetchMustPlayGames() {
        APICaller.shared.fetchGames(url: APIConstants.METACRITIC_URL, expecting: GamesResponse.self) { [weak self] result in
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
        APICaller.shared.fetchGames(url: APIConstants.POPULAR_URL, expecting: GamesResponse.self) { [weak self] result in
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
        APICaller.shared.fetchGames(url: APIConstants.UPCOMING_URL, expecting: GamesResponse.self) { [weak self] result in
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
    
    func fetchDiscoverMoreGames(with page: Int) {
        loadingIndicator()
        APICaller.shared.fetchGamesWithPage(url: APIConstants.DISCOVER_URL, expecting: GamesResponse.self, pageNumber: page) { [weak self] result in
            
            self?.removeLoadingIndicatior()
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.discover += response.results
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
        //prevent double tapping, it causing pushViewController appear twice
        view.isUserInteractionEnabled = false
        
        loadingIndicator()
        
        switch Sections(rawValue: indexPath.section) {
        case .mustPlay:
            APICaller.shared.fetchMainGameDetails(with: mustPlay[indexPath.item].slug) { [weak self]result in
                self?.removeLoadingIndicatior()
                switch result {
                case .success(let gameDetail):
                    DispatchQueue.main.async {
                        vc.configure(with: gameDetail, game: self!.mustPlay[indexPath.item])
                        self?.navigationController?.pushViewController(vc, animated: true)
                        print(gameDetail)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        case .popular:
            APICaller.shared.fetchMainGameDetails(with: popular[indexPath.item].slug) { [weak self]result in
                self?.removeLoadingIndicatior()
                switch result {
                case .success(let gameDetail):
                    DispatchQueue.main.async {
                        vc.configure(with: gameDetail, game:  self!.popular[indexPath.item])
                        self?.navigationController?.pushViewController(vc, animated: true)
                        print(gameDetail)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        case .upcoming:
            APICaller.shared.fetchMainGameDetails(with: upcoming[indexPath.item].slug) { [weak self]result in
                self?.removeLoadingIndicatior()
                switch result {
                case .success(let gameDetail):
                    DispatchQueue.main.async {
                        vc.configure(with: gameDetail, game:  self!.upcoming[indexPath.item])
                        self?.navigationController?.pushViewController(vc, animated: true)
                        print(gameDetail)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        case .discover:
            APICaller.shared.fetchMainGameDetails(with: discover[indexPath.item].slug) { [weak self]result in
                self?.removeLoadingIndicatior()
                switch result {
                case .success(let gameDetail):
                    DispatchQueue.main.async {
                        vc.configure(with: gameDetail, game:  self!.discover[indexPath.item])
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
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        print("offset = \(offsetY)")
        print("contentHeight = \(contentHeight)")
        print("height = \(height)")
        
        if offsetY > contentHeight - height {
            page += 1
            fetchDiscoverMoreGames(with: page)
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
