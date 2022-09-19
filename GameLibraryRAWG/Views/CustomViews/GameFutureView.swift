//
//  GameFutureView.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 30.08.2022.
//

import UIKit

class GameFutureView: UIView {
    
    private let futureTitle: UILabel = {
        let futureTitle = UILabel()
        futureTitle.textColor = .gray
        futureTitle.font = UIFont.boldSystemFont(ofSize: 12)
        futureTitle.translatesAutoresizingMaskIntoConstraints = false
        return futureTitle
    }()
    
    private let futureDescr: UILabel = {
        let futureDescr = UILabel()
        futureDescr.numberOfLines = 0
        futureDescr.translatesAutoresizingMaskIntoConstraints = false
        return futureDescr
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(futureTitle)
        addSubview(futureDescr)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: GameFeaturesViewModel) {
        futureTitle.text = model.gameFeatureTitle
        
        if model.gameFeatureDescr.isEmpty {
            futureDescr.text = "TBA"
        } else {
            futureDescr.text = model.gameFeatureDescr
        }
    }
    
}

extension GameFutureView {
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            
            self.bottomAnchor.constraint(equalTo: futureDescr.bottomAnchor),
            
            futureTitle.topAnchor.constraint(equalTo: self.topAnchor),
            futureTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            futureTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            futureDescr.topAnchor.constraint(equalTo: futureTitle.bottomAnchor, constant: 5),
            futureDescr.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            futureDescr.trailingAnchor.constraint(equalTo: self.trailingAnchor),

        ])
    }
}
