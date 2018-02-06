//
//  PreviewViewController.swift
//  FileSharer
//
//  Created by modao on 2018/2/4.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit
import WebKit

class PreviewViewController: UIViewController {

    private var webview: Preview
    let url: URL

    init(url: URL) {
        self.url = url
        webview = Preview(url: url)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webview)
        webview.snp.makeConstraints({ maker in
            maker.edges.equalToSuperview()
        })
        webview.navigationDelegate = self
        webview.load(URLRequest(url: url))
    }
}

extension PreviewViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView,
                 didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("navigator.userAgent") { value, error in
            if let ua = value as? String {
                print(ua)
            }
        }
    }
}
