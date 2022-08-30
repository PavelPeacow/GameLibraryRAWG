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
        futureDescr.numberOfLines = 3
        futureDescr.adjustsFontSizeToFitWidth = true
        futureDescr.translatesAutoresizingMaskIntoConstraints = false
        return futureDescr
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(futureTitle)
        addSubview(futureDescr)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: GameFutureViewModel) {
        futureTitle.text = model.gameFutureTitle
        futureDescr.text = model.gameFutureDescr
    }
    
}

extension GameFutureView {
    func setConstraints() {
        NSLayoutConstraint.activate([
            futureTitle.topAnchor.constraint(equalTo: self.topAnchor),
            futureTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            futureTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            futureDescr.topAnchor.constraint(equalTo: futureTitle.bottomAnchor, constant: 5),
            futureDescr.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            futureDescr.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1),

        ])
    }
}
