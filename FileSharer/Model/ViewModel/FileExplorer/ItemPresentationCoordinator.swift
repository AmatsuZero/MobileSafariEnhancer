//
//  ItemPresentationCoordinator.swift
//  FileSharer
//
//  Created by modao on 2018/2/7.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

protocol ItemPresentationCoordinatorDelegate: class {
    func itemPresentationCoordinatorDidFinish(_ coordinator: ItemPresentationCoordinator)
    func itemPresentationCoordinator(_ coordinator: ItemPresentationCoordinator, didChooseItems items: [Item<Any>])
}

final class ItemPresentationCoordinator {
    weak var delegate: ItemPresentationCoordinatorDelegate?

    fileprivate weak var navigationController: UINavigationController?
    fileprivate var childCoordinators = [Any]()
    fileprivate var fileSpecifications = FileSpecifications(providers: [FileSpecificationProvider.Type]())
    fileprivate var configuration = Configuration()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(item: Item<Any>, fileSpecifications: FileSpecifications, configuration: Configuration, animated: Bool) {
        guard let navigationController = self.navigationController else { return }
        self.configuration = configuration
        self.fileSpecifications = fileSpecifications
        switch item.type {
        case .file:
            let coordinator = FileItemPresentationCoordinator(navigationController: navigationController, item: item, fileSpecifications: fileSpecifications)
            coordinator.start(animated)
            childCoordinators.append(coordinator)
        case .directory:
            let coordinator = DirectoryItemPresentationCoordinator(navigationController: navigationController, fileSpecifications: fileSpecifications, configuration: configuration)
            coordinator.delegate = self
            coordinator.start(directoryURL: item.url, animated: animated)
            childCoordinators.append(coordinator)
        }
    }

    func stop(_ animated: Bool) {
        childCoordinators.removeAll()
        self.navigationController?.setViewControllers([UIViewController](), animated: animated)
    }
}

extension ItemPresentationCoordinator: DirectoryItemPresentationCoordinatorDelegate {
    func directoryItemPresentationCoordinator(_ coordinator: DirectoryItemPresentationCoordinator, didSelectItem item: Item<Any>) {
        start(item: item, fileSpecifications: fileSpecifications, configuration: configuration, animated: true)
    }

    func directoryItemPresentationCoordinator(_ coordinator: DirectoryItemPresentationCoordinator, didSelectItemDetails item: Item<Any>) {
        guard let navigationController = navigationController else { fatalError() }
        let coordinator = FileItemPresentationCoordinator(navigationController: navigationController, item: item, fileSpecifications: fileSpecifications)
        childCoordinators.append(coordinator)
        coordinator.startDetailsPreview(true)
    }

    func directoryItemPresentationCoordinator(_ coordinator: DirectoryItemPresentationCoordinator, didChooseItems items: [Item<Any>]) {
        delegate?.itemPresentationCoordinator(self, didChooseItems: items)
    }

    func directoryItemPresentationCoordinatorDidFinish(_ coordinator: DirectoryItemPresentationCoordinator) {
        delegate?.itemPresentationCoordinatorDidFinish(self)
    }
}
