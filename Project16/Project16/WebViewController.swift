//
//  WebViewController.swift
//  Project16
//
//  Created by Alperen Çerkez on 29.11.2024.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    var cityURL: URL?
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = cityURL {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
