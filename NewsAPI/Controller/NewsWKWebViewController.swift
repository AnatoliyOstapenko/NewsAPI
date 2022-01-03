//
//  NewsWKWebViewController.swift
//  NewsAPI
//
//  Created by MacBook on 03.01.2022.
//

import UIKit
import WebKit

var webView = WKWebView()

class NewsWKWebViewController: UIViewController {
    
    var newsVC = NewsAPIViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        load(newsVC.webString ?? "https://www.apple.com")
        
        print("I could transfer url from initial VC: \(newsVC.webString ?? "or not((")")
        
        view = webView

    }
    
    
    
    func load(_ urlString: String) {
        
        guard let url = URL(string: urlString) else { return }
        webView.load(URLRequest(url: url))
            }
    
    @IBAction func cancelBarButton(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
}
