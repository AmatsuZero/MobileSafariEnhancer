//
//  URLExtensions.swift
//  FileSharer
//
//  Created by modao on 2018/2/6.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import Foundation

public extension URL {
    /// URL of document directory using user's home directory as search path domain.
    static let documentDirectory: URL = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!)

    /// URL of cache directory using user's home directory as search path domain.
    static let cacheDirectory: URL = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!)
}

extension URL {
    func compare(_ url: URL) -> ComparisonResult {
        return makeStandarizedLastPathComponent().localizedCompare(url.makeStandarizedLastPathComponent())
    }

    func makeStandarizedLastPathComponent() -> String {
        return lastPathComponent.trimmingCharacters(in: CharacterSet.whitespaces)
    }

    func makeStandarizedFirstCharacterOfLastPathComponent() -> Character? {
        return makeStandarizedLastPathComponent().localizedUppercase.first
    }
}
