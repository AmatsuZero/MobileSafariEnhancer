//
//  Store.swift
//  FileSharer
//
//  Created by modao on 2018/2/3.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import MobileCoreServices
import PromiseKit
import MagicalRecord

class Store {

    fileprivate let context: NSExtensionContext
    let groupContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: grounpIdentifier)
    let cookieJar = HTTPCookieStorage.sharedCookieStorage(forGroupContainerIdentifier: grounpIdentifier)
    var sharedURLCache: URLCache?
    var urlComponents: URLComponents?
    static var shared: Store!
    // View-Models
    let headerModel = HeaderViewModel()
    let loginInfoModel = LoginInfoModel()
    var resourceParser: ResourceParser?

    private init(context ctx: NSExtensionContext, completionHander: (()->Void)? = nil) {
        context = ctx
        _ = groupContainerURL?.startAccessingSecurityScopedResource()
        DispatchQueue.global().async {
            for case let obj as NSExtensionItem in ctx.inputItems where obj.attachments != nil {
                for case let itemProvider as NSItemProvider in obj.attachments! where itemProvider.hasItemConformingToTypeIdentifier(kUTTypePropertyList as String) {
                    itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String,
                                          options: nil) { [weak self] item, _ in
                                            if let results = item as? NSDictionary,
                                                let info = results[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary {
                                                    if let baseURI = info["url"] as? String  {
                                                        self?.urlComponents = URLComponents(string: baseURI)
                                                    }
                                                    if let htmlStr = info["htmlStr"] as? String {
                                                        self?.resourceParser = ResourceParser(htmlStr: htmlStr)
                                                    }
                                                    if let cookie = info["cookie"] as? String {
                                                        self?.updateCookieJar(cookieStr: cookie)
                                                    }
                                                self?.updateModel()
                                                completionHander?()
                                            }
                    }
                }
            }
        }
        if let containerURL = groupContainerURL {
            let dbURL = containerURL.appendingPathComponent("sharedDB.sqlite")
            MagicalRecord.setupCoreDataStackWithStore(at: dbURL)
            let fileManager = FileManager.default
            let downloaedURL = containerURL.appendingPathComponent("Downloaded")
            if !fileManager.fileExists(atPath: downloaedURL.path) {
                try? fileManager.createDirectory(at: downloaedURL,
                                                    withIntermediateDirectories: false,
                                                    attributes: nil)
            }
            let downloadingURL = containerURL.appendingPathComponent("Downloading")
            if !fileManager.fileExists(atPath: downloadingURL.path) {
                try? fileManager.createDirectory(at: downloadingURL,
                                                 withIntermediateDirectories: false,
                                                 attributes: nil)
            }
        }
    }

    class func createStore(context: NSExtensionContext,
                           completionHander: (()->Void)? = nil) {
        Store.shared = Store(context: context, completionHander: completionHander)

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

    fileprivate func updateCookieJar(cookieStr: String)  {
        cookieStr.components(separatedBy: ";").forEach { single in
            if let cookie = single.cookie(domain: urlComponents?.host) {
                cookieJar.setCookie(cookie)
            }
        }
        Network.shared.setCookieStorage(cookieJar)
    }

    fileprivate func updateModel()  {
        if let components = urlComponents, let host = components.host {
            headerModel.setValue(imageURL: try! Router.favicon(domain: host) .asURL(),
                                 address: host)
            loginInfoModel.initializeFillText(server: host,
                                              protocal: components.scheme!)
        }
    }

    func beforeQuit() {
        if let containerURL = groupContainerURL {
            MagicalRecord.cleanUp()
            containerURL.stopAccessingSecurityScopedResource()
        }
    }
}
