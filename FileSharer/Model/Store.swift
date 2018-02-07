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
            if let components = urlComponents, let host = components.host {
                headerModel.setValue(imageURL: try! Router.favicon(domain: host) .asURL(),
                                     address: host)
                loginInfoModel.initializeFillText(server: host,
                                                  protocal: components.scheme!)
            }
        }
    }
    static var shared: Store!
    // View-Models
    let headerModel = HeaderViewModel()
    let loginInfoModel = LoginInfoModel()
    var resourceParser: ResourceParser?

    private init(context ctx: NSExtensionContext) {
        context = ctx
        DispatchQueue.global().async {
            for case let obj as NSExtensionItem in ctx.inputItems where obj.attachments != nil {
                for case let itemProvider as NSItemProvider in obj.attachments! where itemProvider.hasItemConformingToTypeIdentifier(kUTTypePropertyList as String) {
                    itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String,
                                          options: nil) { [weak self] item, _ in
                                            if let results = item as? NSDictionary,
                                                let info = results[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary,
                                                let baseURI = info["url"] as? String  {
                                                self?.urlComponents = URLComponents(string: baseURI)
                                                if let htmlStr = info["htmlStr"] as? String {
                                                    self?.resourceParser = ResourceParser(htmlStr: htmlStr)
                                                }
                                            }
                    }
                }
            }
        }
    }

    class func createStore(context: NSExtensionContext) {
        Store.shared = Store(context: context)
    }

    //TODO: 这里目前只有判断钥匙串里面是否已经有保存的信息，对于一些暂不需要登录信息就能下载的地址，也可以直接忽略
    //如果后缀是资源类型，直接通过head请求，判断能否下载，返回403错误，再尝试鉴权
    func needLogin() -> Promise<Bool> {
        guard let url = urlComponents?.url else {
            return Promise(value: false)
        }
        return Network.shared.valid(url: url).then { response in
            let downloadadbleTypes = ["text/plain",
                                      "image/gif", "image/png", "image/jpeg", "image/bmp", "image/webp",
                                      "video/webm", "video/ogg", "video/3gp", "video/mp4"]
            if response?.statusCode == 403 {
                return Promise(value: true)
            } else if downloadadbleTypes.contains(response?.mimeType ?? "") {
                return Promise(value: false)
            } else {// 检查尺寸
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
    }
}
