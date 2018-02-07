//
//  FileItemPresentationCoordinator.swift
//  FileSharer
//
//  Created by modao on 2018/2/7.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

final class FileItemPresentationCoordinator {
    fileprivate weak var navigationController: UINavigationController?
    fileprivate let fileService: FileService
    fileprivate let fileSpecifications: FileSpecifications
    fileprivate let item: Item<Any>

    init(navigationController: UINavigationController, item: Item<Any>, fileSpecifications: FileSpecifications, fileService: FileService = LocalStorageFileService()) {
        self.navigationController = navigationController
        self.item = item
        self.fileSpecifications = fileSpecifications
        self.fileService = fileService
    }

    func start(_ animated: Bool) {
        switch item.type {
        case .file:
            let viewController = makePresentingViewController(item: item) { [weak self] loadedItem in
                guard let strongSelf = self else { fatalError() }
                let castedLoadedItem = loadedItem.cast() as LoadedItem<Data>
                let viewController = strongSelf.fileSpecifications.itemSpecification(for: strongSelf.item).viewControllerForItem(at: loadedItem.url, data: castedLoadedItem.resource, attributes: loadedItem.attributes)
                viewController.navigationItem.title = strongSelf.item.name
                return viewController
            }
            navigationController?.pushViewController(viewController, animated: animated)
        case .directory:
            fatalError()
        }
    }

    func startDetailsPreview(_ animated: Bool) {
        let fileSpecification = fileSpecifications.itemSpecification(for: item)
        let viewController = makePresentingViewController(item: item) { loadedItem in
            let viewModel = FileViewModel(item: loadedItem, specification: fileSpecification)
            return FileViewController(viewModel: viewModel)
        }
        navigationController?.pushViewController(viewController, animated: animated)
    }

    private func makePresentingViewController(item: Item<Any>, builder: @escaping (LoadedItem<Any>) -> UIViewController) -> UIViewController {
        let viewController = LoadingViewController<Any>.make(item: item) { [weak self] loadedItem in
            let contentViewController = builder(loadedItem)
            let actionsViewController = ActionsViewController(contentViewController: contentViewController)
            actionsViewController.delegate = self
            return actionsViewController
        }
        return viewController
    }
}

extension FileItemPresentationCoordinator: ActionsViewControllerDelegate {
    func actionsViewControllerDidRequestShare(_ controller: ActionsViewController) {
        let activityItem = UIActivityItemProvider(placeholderItem: item.url)
        let activityViewController = UIActivityViewController(activityItems: [activityItem], applicationActivities: nil)
        navigationController?.present(activityViewController, animated: true, completion: nil)
    }

    func actionsViewControllerDidRequestRemoval(_ controller: ActionsViewController) {
        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.fileService.delete(items: [strongSelf.item]) { result, removedItems, itemsNotRemovedDueToFailure in
                guard let navigationController = strongSelf.navigationController else { return }
                if case .error(let error) = result {
                    UIAlertController.presentAlert(for: error, in: navigationController)
                }
            }
        }
        _ = navigationController?.popViewController(animated: true)
        CATransaction.commit()
    }
}
