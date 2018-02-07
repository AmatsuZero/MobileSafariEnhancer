//
//  DirectoryViewModel.swift
//  FileSharer
//
//  Created by modao on 2018/2/7.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import Foundation

final class DirectoryViewModel {
    internal let finishButtonHidden: Bool
    private let url: URL
    private let item: LoadedDirectoryItem
    private let fileSpecifications: FileSpecifications
    private let configuration: Configuration

    init(url: URL, item: LoadedDirectoryItem,
         fileSpecifications: FileSpecifications,
         configuration: Configuration, finishButtonHidden: Bool) {
        self.url = url
        self.item = item
        self.fileSpecifications = fileSpecifications
        self.configuration = configuration
        self.finishButtonHidden = finishButtonHidden
    }

    var finishButtonTitle: String {
        if configuration.actionsConfiguration.canChooseFiles || configuration.actionsConfiguration.canChooseDirectories {
            return NSLocalizedString("Cancel", comment: "")
        } else {
            return NSLocalizedString("Done", comment: "")
        }
    }

    func makeDirectoryContentViewModel() -> DirectoryContentViewModel {
        return DirectoryContentViewModel(item: item, fileSpecifications: fileSpecifications, configuration: configuration)
    }
}
