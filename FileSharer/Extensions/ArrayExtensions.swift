//
//  ArrayExtensions.swift
//  FileSharer
//
//  Created by modao on 2018/2/6.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import Foundation


extension Array where Element: Equatable {
    @discardableResult
    mutating func remove(_ item: Element) -> Bool {
        let index = self.index() { $0 == item }
        if let index = index {
            remove(at: index)
            return true
        } else {
            return false
        }
    }
}

extension Sequence where Iterator.Element == Filter {
    func matchesItem(_ item: Item<Any>) -> Bool {
        for filter in self {
            if filter.matchesItem(item) {
                return true
            }
        }
        return false
    }
}
