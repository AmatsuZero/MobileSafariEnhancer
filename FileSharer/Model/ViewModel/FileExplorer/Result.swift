//
//  Result.swift
//  FileSharer
//
//  Created by modao on 2018/2/6.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(Error)

    init(_ f: () throws -> T) {
        do {
            self = .success(try f())
        } catch {
            self = .error(error)
        }
    }
    func map<U>(_ transform: (T) -> U) -> Result<U> {
        return flatMap({ .success(transform($0)) })
    }
    func flatMap<U>(_ transform: (T) -> Result<U>) -> Result<U> {
        switch self {
        case .success(let value):
            return transform(value)
        case .error(let e):
            return .error(e)
        }
    }
    var isSuccess: Bool {
        get {
            switch self {
            case .success:
                return true
            case .error:
                return false
            }
        }
    }
}
