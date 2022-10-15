//
//  GameFutureView.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 30.08.2022.
//

import UIKit

class GameFeautureView: UIView {
    
    private let feautureTitle: UILabel = {
        let futureTitle = UILabel()
        futureTitle.textColor = .gray
        futureTitle.font = UIFont.boldSystemFont(ofSize: 12)
        futureTitle.translatesAutoresizingMaskIntoConstraints = false
        return futureTitle
    }()
    
    private let feautureDescr: UILabel = {
        let futureDescr = UILabel()
        futureDescr.numberOfLines = 0
        futureDescr.translatesAutoresizingMaskIntoConstraints = false
        return futureDescr
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(feautureTitle)
        addSubview(feautureDescr)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: GameFeaturesViewModel) {
        feautureTitle.text = model.gameFeatureTitle
        
        if model.gameFeatureDescr.isEmpty {
            feautureDescr.text = "TBA"
        } else {
            feautureDescr.text = model.gameFeatureDescr
        }
    }
    
}

extension GameFeautureView {
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            
            self.bottomAnchor.constraint(equalTo: feautureDescr.bottomAnchor),
            
            feautureTitle.topAnchor.constraint(equalTo: self.topAnchor),
            feautureTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            feautureTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            feautureDescr.topAnchor.constraint(equalTo: feautureTitle.bottomAnchor, constant: 5),
            feautureDescr.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            feautureDescr.trailingAnchor.constraint(equalTo: self.trailingAnchor),

        ])
    }
}
