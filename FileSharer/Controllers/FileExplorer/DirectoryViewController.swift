//
//  DirectoryViewController.swift
//  FileSharer
//
//  Created by modao on 2018/2/7.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit

protocol DirectoryViewControllerDelegate: class {
    func directoryViewController(_ controller: DirectoryViewController, didSelectItem item: Item<Any>)
    func directoryViewController(_ controller: DirectoryViewController, didSelectItemDetails item: Item<Any>)
    func directoryViewController(_ controller: DirectoryViewController, didChooseItems items: [Item<Any>])
    func directoryViewControllerDidFinish(_ controller: DirectoryViewController)
}

final class DirectoryViewController: UIViewController {
    weak var delegate: DirectoryViewControllerDelegate?
    fileprivate let viewModel: DirectoryViewModel
    fileprivate let searchController: UISearchController
    fileprivate let searchResultsController: DirectoryContentViewController
    fileprivate let searchResultsViewModel: DirectoryContentViewModel
    fileprivate let directoryContentViewController: DirectoryContentViewController
    fileprivate let directoryContentViewModel: DirectoryContentViewModel

    init(viewModel: DirectoryViewModel) {
        self.viewModel = viewModel

        searchResultsViewModel = viewModel.makeDirectoryContentViewModel()
        searchResultsController = DirectoryContentViewController(viewModel: searchResultsViewModel)
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = searchResultsController

        directoryContentViewModel = viewModel.makeDirectoryContentViewModel()
        directoryContentViewController = DirectoryContentViewController(viewModel: directoryContentViewModel)

        super.init(nibName: nil, bundle: nil)

        searchResultsController.delegate = self
        directoryContentViewController.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = false
        edgesForExtendedLayout = []
        setUpSearchBarController()
        addContentChildViewController(directoryContentViewController,
                                      insets: UIEdgeInsets(top: searchController.searchBar.bounds.height,
                                                           left: 0.0,
                                                           bottom: 0.0,
                                                           right: 0.0))
        navigationItem.rightBarButtonItem = directoryContentViewController.navigationItem.rightBarButtonItem
        navigationItem.title = directoryContentViewController.navigationItem.title
        view.sendSubview(toBack: directoryContentViewController.view)
        setUpLeftBarButtonItem()
    }

    func setUpSearchBarController() {
        let searchBar = searchController.searchBar
        searchBar.sizeToFit()
        searchBar.autoresizingMask = [.flexibleWidth]
        searchBar.delegate = self
        view.addSubview(searchBar)
        navigationItem.rightBarButtonItems = directoryContentViewController.navigationItem.rightBarButtonItems
    }

    func setUpLeftBarButtonItem() {
        if !viewModel.finishButtonHidden {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: viewModel.finishButtonTitle,
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(DirectoryViewController.handleFinishButtonTap))
        }
    }

    var isSearchControllerActive: Bool {
        get {
            return searchController.isActive
        }
        set(newValue) {
            searchController.isActive = newValue
        }
    }

    // MARK: Actions
    @objc func handleFinishButtonTap() {
        delegate?.directoryViewControllerDidFinish(self)
    }
}

extension DirectoryViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        directoryContentViewController.setEditing(false, animated: true)
        searchResultsViewModel.sortMode = directoryContentViewModel.sortMode
    }
}

extension DirectoryViewController: DirectoryContentViewControllerDelegate {
    func directoryContentViewController(_ controller: DirectoryContentViewController, didChangeEditingStatus isEditing: Bool) {
        searchController.searchBar.isEnabled = !isEditing
    }

    func directoryContentViewController(_ controller: DirectoryContentViewController, didSelectItem item: Item<Any>) {
        delegate?.directoryViewController(self, didSelectItem: item)
    }

    func directoryContentViewController(_ controller: DirectoryContentViewController, didSelectItemDetails item: Item<Any>) {
        delegate?.directoryViewController(self, didSelectItemDetails: item)
    }

    func directoryContentViewController(_ controller: DirectoryContentViewController, didChooseItems items: [Item<Any>]) {
        delegate?.directoryViewController(self, didChooseItems: items)
    }
}
