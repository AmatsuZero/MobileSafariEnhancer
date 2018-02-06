//
//  FileService.swift
//  FileSharer
//
//  Created by modao on 2018/2/6.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import Foundation
import PromiseKit

protocol FileService: class {
    func load(item: Item<Any>, completionBlock: @escaping (Result<LoadedItem<Any>>) -> ())
    func delete(items: [Item<Any>], completionBlock: @escaping (_ result: Result<Void>, _ removedItems: [Item<Any>], _ itemsNotRemovedDueToFailure: [Item<Any>]) -> Void)
    var isDeletionInProgress: Bool { get }
}

enum FileServiceError: Error {
    case removalFailure(removedItems: [Item<Any>], itemsNotRemovedDueToFailure: [Item<Any>])
    case loadingFailure()
}

extension Notification.Name {
    static let ItemsDeleted = Notification.Name("ItemsDeleted")
}


final class LocalStorageFileService: FileService {
    private let fileManager: FileManager
    var isDeletionInProgress = false

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    func load(item: Item<Any>, completionBlock: @escaping (Result<LoadedItem<Any>>) -> ()) {
        DispatchQueue.global(qos: .default).async {
            let result = Result<LoadedItem<Any>>() { [weak self] in
                guard let strongSelf = self else { throw FileServiceError.loadingFailure() }
                let attributes = try strongSelf.fileManager.attributesOfItem(atPath: item.url.path)
                let result: Any

                if item.type == ItemType.directory {
                    let urls = try FileManager.default.contentsOfDirectory(at: item.url,
                                                                           includingPropertiesForKeys: [URLResourceKey.isDirectoryKey, URLResourceKey.contentModificationDateKey],
                                                                           options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
                    result = item.parse(attributes, nil, urls)!
                } else {
                    let data = try Data.init(contentsOf: item.url)
                    result = item.parse(attributes, data, nil)!
                }
                return LoadedItem(item: item, attributes: attributes, resource: result)
            }
            DispatchQueue.main.async {
                completionBlock(result)
            }
        }
    }

    func delete(items: [Item<Any>], completionBlock: @escaping (_ result: Result<Void>, _ deletedItems: [Item<Any>], _ itemsNotDeletedDueToFailure: [Item<Any>]) -> Void) {
        guard !isDeletionInProgress else { return }
        isDeletionInProgress = true
        var deletedItems = [Item<Any>]()
        var itemsNotRemovedDueToFailure = [Item<Any>]()
        DispatchQueue.global(qos: .default).async() { [weak self] in
            guard let strongSelf = self else { return }
            for item in items {
                do {
                    try strongSelf.fileManager.removeItem(at: item.url)
                    deletedItems.append(item)
                } catch {
                    itemsNotRemovedDueToFailure.append(item)
                }
            }
            DispatchQueue.main.async {
                if deletedItems.count > 0 {
                    NotificationCenter.default.post(name: .ItemsDeleted, object: deletedItems)
                }
                strongSelf.isDeletionInProgress = false
                if itemsNotRemovedDueToFailure.count > 0 {
                    completionBlock(.error(FileServiceError.removalFailure(removedItems: deletedItems,
                                                                           itemsNotRemovedDueToFailure: itemsNotRemovedDueToFailure)),
                                    deletedItems,
                                    itemsNotRemovedDueToFailure)
                } else {
                    completionBlock(.success(()), deletedItems, itemsNotRemovedDueToFailure)
                }
            }
        }
    }
}
