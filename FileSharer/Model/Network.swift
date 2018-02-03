//
//  Network.swift
//  FileSharer
//
//  Created by modao on 2018/2/3.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import Alamofire
import SwiftyJSON
import PromiseKit

enum Router: URLConvertible, URLRequestConvertible {

    case favicon(domain: String)
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    var path: String {
        switch self {
        case .favicon(let domain):
            var components = URLComponents(string: "http://www.google.com/s2/favicons")!
            components.queryItems = [
                URLQueryItem.init(name: "domain", value: domain)
            ]
            return components.string!
        }
    }

    func asURL() throws -> URL {
        switch self {
        default:
            return URL(string: path)!
        }
    }

    func asURLRequest() throws -> URLRequest {
        switch self {
        default:
            return try URLRequest(url: asURL(), method: method)
        }
    }
}

class Network {
    let sessionManager = SessionManager(configuration: .default)
}
