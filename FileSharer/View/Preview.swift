//
//  Preview.swift
//  FileSharer
//
//  Created by modao on 2018/2/4.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import WebKit

class Preview: WKWebView {

    init(url: URL) {
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptEnabled = true
        // load jquery
        if let path = Bundle.main.path(forResource: "jquery", ofType: "js"),
            let jq = try? String(contentsOfFile: path, encoding: .utf8) {
            let script = WKUserScript(source: jq,
                                      injectionTime: .atDocumentEnd,
                                      forMainFrameOnly: true)
            config.userContentController.addUserScript(script)
        }
        // Set cookies
        Store.shared.cookieJar.cookies(for: url)?.forEach({ cookie in
            config.websiteDataStore.httpCookieStore.setCookie(cookie, completionHandler: nil)
        })
        super.init(frame: .zero, configuration: config)
        // 伪装成桌面浏览器
        customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3) AppleWebKit/604.5.6 (KHTML, like Gecko) Version/11.0.3 Safari/604.5.6"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
