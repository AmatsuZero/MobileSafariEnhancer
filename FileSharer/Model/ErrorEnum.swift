//
//  Enum.swift
//  FileSharer
//
//  Created by modao on 2018/2/3.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import Foundation

enum TaskError: Error {
    case cancel(userInfo: [String: Any]?)
    static let errorDomain = "com.daubert.FileSharerError"

    var instance: Error {
        switch self {
        case .cancel(let info):
            return NSError(domain: TaskError.errorDomain,
                           code: -3001,
                           userInfo: info)
        }
    }
}

enum CustomErrors {
    static let domain = "FileExplorerDomain"

    static let nilItem = NSError(domain: domain,
                                 code: 1,
                                 userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Passed URL is incorrect or item at specified URL doesn't exist", comment: "")])
    static let incorrectDirectoryURL = NSError(domain: domain,
                                               code: 1,
                                               userInfo: [
                                                NSLocalizedDescriptionKey: NSLocalizedString("Passed URL is incorrect or item at specified URL isn't a directory", comment: "")])
}
