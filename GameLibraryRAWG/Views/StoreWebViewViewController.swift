//
//  StoreWebViewViewController.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 02.09.2022.
//

import UIKit
import WebKit

class StoreWebViewViewController: UIViewController {
    
    private var webView = WKWebView()
    public var storeUrl: String?
    
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadStore()
    }
    
    private func loadStore() {
        guard let url = URL(string: storeUrl!) else { return }
        let myRequest = URLRequest(url: url)
        webView.load(myRequest)
    }


}
