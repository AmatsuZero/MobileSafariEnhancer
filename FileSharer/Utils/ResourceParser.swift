//
//  ResourceParser.swift
//  FileSharer
//
//  Created by modao on 2018/2/4.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import Foundation
import PromiseKit

struct ResourceLink {
    enum LinkType: Int {
        case unknown = 0, ed2k, magnet, http, bt
    }
    var link = ""
    var name = ""
    var type = LinkType.unknown
}

class ResourceParser {

    private var document:HTMLDocument?

    init(htmlStr: String) {
        document = try? HTMLDocument(htmlString: htmlStr)
    }

    func getEd2kResources() -> Promise<[ResourceLink]> {
        return firstly {
            return Promise { resolve, reject in
                DispatchQueue.global().async {
                    resolve(self.document?.rootNode?.nodes(forXPath: "//a[@href]"))
                }
            }
            }.then(on: DispatchQueue.global()) { nodes -> [ResourceLink] in
                var results = [ResourceLink]()
                nodes?.filter({$0.htmlString?.length ?? 0 > 200 })
                    .map({return $0.htmlString!})
                    .forEach({ raw in
                        var ed2k = ""
                        if raw.components(separatedBy: "ed2k://").count >= 2 { // 查找ed2k链接
                            let range = raw.range(of: "ed2k://.*.\\|\\/", options: .regularExpression)
                            let strClearArray = raw.substring(with: range).components(separatedBy: "|/")
                            if strClearArray.count < 2 {
                                ed2k = raw as String
                            } else {
                                ed2k = "\(strClearArray.first!)|/"
                            }
                            results.append(ResourceLink(link: ed2k, name: ed2k.searchEd2kName(), type: .ed2k))
                        } else if raw.components(separatedBy: "magnet:?").count >= 2 { // 查找磁力链接
                            let range = raw.range(of: "magnet:?[^\"]+", options: .regularExpression)
                            ed2k = raw.substring(with: range)
                        }
                        if !ed2k.isEmpty {
                            results.append(ResourceLink(link: ed2k, name: ed2k.searchEd2kName(), type: .magnet))
                        }
                    })
                return results
            }.then(on: DispatchQueue.global()) { results in // 查找非标签内的ed2k
                guard results.isEmpty else {
                    return Promise(value: results)
                }
                let nodes = self.document?.rootNode?.nodes(forXPath: "/*")
                return Promise(value: self.sortout(resources: nodes))
        }
    }

    func sortout(resources: [HTMLNode]?) -> [ResourceLink] {
        let clearEd2kStr: (String) -> String = { ed2k in
            let start = ed2k.range(of: "ed2k://", options: .regularExpression)?.lowerBound
            let end = ed2k.range(of: "|/", options: .regularExpression)?.upperBound
            return String(ed2k[start!...end!])
        }
        var ed2kSets = [String]()
        resources?.forEach { node in
            if let clearEd2ks = node.rawStringValue?.components(separatedBy: "|/")
                .filter({ NSString(format: "%@|/", $0).range(of:"ed2k://.*.\\|\\/",
                                                             options: .regularExpression).length > 10})
                .map({return "\($0)|/"})
                .map(clearEd2kStr)
                .map(clearEd2kStr) {
                ed2kSets.append(contentsOf: clearEd2ks)
            }
        }
        return ed2kSets.sorted().map({return ResourceLink(link: $0, name: $0.searchEd2kName(), type: .ed2k)})
    }
}
