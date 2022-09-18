//
//  LoadingNewPage.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 04.09.2022.
//

import Foundation
import UIKit

fileprivate let containerTagId = 1337

extension UIViewController {
    
    private func getContainerView() -> UIView? {
        view.viewWithTag(containerTagId)
    }
    
    private func isDisplayingIndicator() -> Bool {
        getContainerView() != nil
    }
    
    func loadingIndicator() {
        guard !isDisplayingIndicator() else { return }
        
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.tag = containerTagId
        
        view.addSubview(container)
        
        container.backgroundColor = .systemBackground
        container.alpha = 0
        
        UIView.animate(withDuration: 0.3) { container.alpha = 0.8 }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            container.widthAnchor.constraint(equalTo: view.widthAnchor),
            container.heightAnchor.constraint(equalTo: view.heightAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    func removeLoadingIndicator() {
        DispatchQueue.main.async {
            if let container = self.view.viewWithTag(1337) {
                
                UIView.animate(withDuration: 0.2, animations: {
                    container.alpha = 0.0
                }) { animationEnd in
                    container.removeFromSuperview()
                }
                
            }
        }
    }
    
}
