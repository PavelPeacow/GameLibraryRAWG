//
//  ScreenshotPreviewViewController.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 04.09.2022.
//

import UIKit
import SDWebImage

class ScreenshotPreviewViewController: UIViewController {
    
    private let screenshotPreview: UIImageView = {
        let screenshotPreview = UIImageView()
        screenshotPreview.contentMode = .scaleAspectFit
        return screenshotPreview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(screenshotPreview)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        screenshotPreview.frame = view.bounds
    }
    
    public func configure(with image: String) {
        guard let url = URL(string: image) else { return }
        screenshotPreview.sd_imageIndicator = SDWebImageActivityIndicator.large
        screenshotPreview.sd_setImage(with: url)
    }
    
    
}
