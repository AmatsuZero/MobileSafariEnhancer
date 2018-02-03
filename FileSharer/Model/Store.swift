//
//  Store.swift
//  FileSharer
//
//  Created by modao on 2018/2/3.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import Foundation
import MobileCoreServices

class Store {

    fileprivate let context: NSExtensionContext
    fileprivate let network = Network()
    var urlComponents: URLComponents? {
        didSet {
            if let components = urlComponents, let host = components.host {
                DispatchQueue.main.async { [weak self] in
                    self?.headerModel.imageURL = try? Router.favicon(domain: host) .asURL()
                    self?.headerModel.titleLable.text = host
                }
            }
        }
    }
    static var shared: Store!
    let headerModel = HeaderViewModel()

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
}
