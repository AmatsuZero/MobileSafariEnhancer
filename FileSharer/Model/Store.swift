//
//  Store.swift
//  FileSharer
//
//  Created by modao on 2018/2/3.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import Foundation
import MobileCoreServices
import PromiseKit

class Store {

    fileprivate let context: NSExtensionContext
    fileprivate let network = Network()
    let cookieJar = HTTPCookieStorage.sharedCookieStorage(forGroupContainerIdentifier: grounpIdentifier)

    var urlComponents: URLComponents? {
        didSet {
            if let components = urlComponents, let host = components.host, let url = components.url {
                headerModel.setValue(imageURL: try! Router.favicon(domain: host) .asURL(),
                                     address: host)
                loginInfoModel.initializeFillText(server: host,
                                                  protocal: components.scheme!)
                previewController.loadRequest(url: url)
            }
        }
    }
    static var shared: Store!
    // View-Models
    let headerModel = HeaderViewModel()
    let loginInfoModel = LoginInfoModel()
    // Preview controller
    let previewController = PreviewViewController()

    private init(context ctx: NSExtensionContext) {
        context = ctx
        for case let obj as NSExtensionItem in ctx.inputItems where obj.attachments != nil {
            for case let itemProvider as NSItemProvider in obj.attachments! where itemProvider.hasItemConformingToTypeIdentifier(kUTTypePropertyList as String) {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String,
                                      options: nil) { item, _ in
                                        if let results = item as? NSDictionary,
                                            let info = results[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary,
                                            let baseURI = info["url"] as? String  {
                                            self.urlComponents = URLComponents(string: baseURI)
                                        }
                }
            }
        }
    }

    class func createStore(context: NSExtensionContext) {
        Store.shared = Store(context: context)
    }

    func needLogin() -> Promise<Bool> {
        guard let url = urlComponents?.url else {
            return Promise(value: false)
        }
        return Promise { resolve, _ in
            if let host = url.host, let scheme = url.scheme {
                self.loginInfoModel.getLastLoginInfo(server: host, protocol: scheme).then { info -> Void in
                    resolve(info == nil)
                }.catch { error in
                    resolve(false)
                }
            } else {
                resolve(true)
            }
        }
    }
}
