//
//  DetailViewController.swift
//  Project7
//
//  Created by Alperen Çerkez on 1.10.2024.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?

    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let detailItem = detailItem else { return }

        // Inject custom CSS into the HTML content
        let html = """
        <html>
        <head>
        <style>
        body { font-size: 150%; color: darkgray; }
        h1 { color: darkblue; }
        </style>
        </head>
        <body>
        <h1>\(detailItem.title)</h1>
        <p>\(detailItem.body)</p>
        </body>
        </html>
        """

        webView.loadHTMLString(html, baseURL: nil)
    }
}
