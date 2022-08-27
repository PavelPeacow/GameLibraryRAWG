//
//  LoadImage.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 27.08.2022.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImageFromURL(from imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        
        self.image = nil
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, _, error) in
            
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                let dowloadedImage = UIImage(data: data)
                self.image = dowloadedImage
            }
            
        }
        task.resume()
        
    }
}
