//
//  NewsWKWebViewController.swift
//  NewsAPI
//
//  Created by MacBook on 03.01.2022.
//

import UIKit
import WebKit



class NewsWKWebViewController: UIViewController {
    
    var webView = WKWebView()
    var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = webView
        guard let currentURL = url else { return }
        load(currentURL)
        
        navigationController?.navigationBar.tintColor = .white // Back botton color is changed to white
        
    }
    
    
    
    func load(_ urlString: String) {
        
        guard let url = URL(string: urlString) else { return }
        webView.load(URLRequest(url: url))
    }
    
}
