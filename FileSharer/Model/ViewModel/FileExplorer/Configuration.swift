//
//  Configuration.swift
//  FileSharer
//
//  Created by modao on 2018/2/6.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import Foundation

struct Configuration {
    var actionsConfiguration = ActionsConfiguration()
    var filteringConfiguration = FilteringConfiguration()
}

struct ActionsConfiguration {
    var canRemoveFiles: Bool = false
    var canRemoveDirectories: Bool = false
    var canChooseFiles: Bool = false
    var canChooseDirectories: Bool = false
    var allowsMultipleSelection: Bool = false
}

struct FilteringConfiguration {
    var fileFilters: [Filter]
    var ignoredFileFilters: [Filter]
}

extension FilteringConfiguration {
    init() {
        self.init(fileFilters: [Filter](), ignoredFileFilters: [Filter]())
    }
}

enum Filter {
    case `extension`(String)
    case type(ItemType)
    case lastPathComponent(String)
    case modificationDatePriorTo(Date)
    case modificationDatePriorOrEqualTo(Date)
    case modificationDatePast(Date)
    case modificationDatePastOrEqualTo(Date)

    func matchesItem(_ item: Item<Any>) -> Bool {
        return matchesItem(withLastPathComponent: item.url.lastPathComponent, type: item.type, modificationDate: item.modificationDate)
    }

    func matchesItem(withLastPathComponent lastPathComponent: String, type: ItemType, modificationDate: Date) -> Bool {
        switch self {
        case .`extension`(let `extension`):
            return `extension` == (lastPathComponent as NSString).pathExtension
        case .type(let t):
            return t == type
        case .lastPathComponent(let lastPathComp):
            return lastPathComponent == lastPathComp
        case .modificationDatePriorTo(let date):
            return modificationDate.timeIntervalSince(date) < 0
        case .modificationDatePriorOrEqualTo(let date):
            return modificationDate.timeIntervalSince(date) <= 0
        case .modificationDatePast(let date):
            return modificationDate.timeIntervalSince(date) > 0
        case .modificationDatePastOrEqualTo(let date):
            return modificationDate.timeIntervalSince(date) >= 0
        }
    }
}
