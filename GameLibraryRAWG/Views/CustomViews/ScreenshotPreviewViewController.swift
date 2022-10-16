//
//  ScreenshotPreviewViewController.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 04.09.2022.
//

import UIKit
import SDWebImage

class ScreenshotPreviewViewController: UIViewController {
    
    private let scrollView: UIScrollView = UIScrollView()
    
    private let screenshotPreview: UIImageView = {
        let screenshotPreview = UIImageView()
        screenshotPreview.contentMode = .scaleAspectFit
        return screenshotPreview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(screenshotPreview)
        
        setZoomScale()
        setDelegates()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        screenshotPreview.frame = view.bounds
        scrollView.frame = view.bounds
    }
    
    public func configure(with image: String) {
        guard let url = URL(string: image) else { return }
        screenshotPreview.sd_imageIndicator = SDWebImageActivityIndicator.large
        screenshotPreview.sd_setImage(with: url)
    }
    
    private func setDelegates() {
        scrollView.delegate = self
    }
    
    private func setZoomScale() {
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
    }
    
}

extension ScreenshotPreviewViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return screenshotPreview
    }
}
