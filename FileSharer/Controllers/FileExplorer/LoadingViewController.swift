//
//  LoadingViewController.swift
//  FileSharer
//
//  Created by modao on 2018/2/7.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit

final class LoadingViewController<T>: UIViewController {

    init(load: @escaping (@escaping (Result<LoadedItem<T>>) -> ()) -> (), builder: @escaping (LoadedItem<T>) -> UIViewController?) {
        super.init(nibName: nil, bundle: nil)
        extendedLayoutIncludesOpaqueBars = false
        edgesForExtendedLayout = []
        showLoadingIndicator()
        load({ [weak self] result in
            guard let strongSelf = self else { return }
            strongSelf.hideLoadingIndicator()
            switch result {
            case .success(let item):
                let contentViewController = builder(item)!
                strongSelf.addContentChildViewController(contentViewController)
                strongSelf.navigationItem.title = contentViewController.navigationItem.title
                strongSelf.navigationItem.rightBarButtonItems = contentViewController.navigationItem.rightBarButtonItems
                strongSelf.navigationItem.leftBarButtonItems = contentViewController.navigationItem.leftBarButtonItems
                strongSelf.extendedLayoutIncludesOpaqueBars = contentViewController.extendedLayoutIncludesOpaqueBars
                strongSelf.edgesForExtendedLayout = contentViewController.edgesForExtendedLayout
            case .error(let error):
                UIAlertController.presentAlert(for: error, in: strongSelf)
            }
        })
    }

    required  init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}

extension LoadingViewController {
    class func make(item: Item<Any>?,
                    fileService: FileService = LocalStorageFileService(),
                    builder: @escaping (LoadedItem<Any>) -> UIViewController?) -> LoadingViewController<Any> {
        return LoadingViewController<Any>(load: { completionBlock in
            guard let item = item else {
                completionBlock(Result.error(CustomErrors.nilItem))
                return
            }
            fileService.load(item: item, completionBlock: completionBlock)
        }, builder: builder)
    }
}
