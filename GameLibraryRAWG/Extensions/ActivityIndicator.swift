//
//  LoadingNewPage.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 04.09.2022.
//

import Foundation
import UIKit

fileprivate var container = UIView()

extension ActivityIndicator where Self: UIViewController {
    
    func loadingIndicator() {
        container = UIView(frame: view.bounds)
        
        view.addSubview(container)
        
        container.backgroundColor = .systemBackground
        container.alpha = 0
        
        UIView.animate(withDuration: 0.3) { container.alpha = 0.8 }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    func removeLoadingIndicator() {
        DispatchQueue.main.async {
            container.removeFromSuperview()
        }
    }
    
}
