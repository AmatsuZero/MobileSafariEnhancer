//
//  FileExploreViewController.swift
//  FileSharer
//
//  Created by modao on 2018/2/7.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit

/// The FileExplorerViewControllerDelegate protocol defines methods that your delegate object must implement to interact with the file explorer interface. The methods of this protocol notify your delegate when the user chooses files and/or directories, or finishes the file explorer presentation operation.
protocol FileExplorerViewControllerDelegate: class {

    /// Tells the delegate that the user finished presentation of the file explorer.
    ///
    /// - Parameter controller: The controller object managing the file explorer interface.
    func fileExplorerViewControllerDidFinish(_ controller: FileExplorerViewController)

    /// Tells the delegate that the user chose files and/or directories.
    ///
    /// File explorer hides itself after uses chooses files and/or directories.
    /// - Parameters:
    ///   - controller: The controller object managing the file explorer interface.
    ///   - urls: URLs choosen by users.
    func fileExplorerViewController(_ controller: FileExplorerViewController, didChooseURLs urls: [URL])
}

/// The FileExplorerViewController class manages customizable for displaying, removing and choosing files and directories stored in local storage of the device in your app. A file explorer view controller manages user interactions and delivers the results of those interactions to a delegate object.
final class FileExplorerViewController: UIViewController {

    /// The URL of directory which is initialy presented by file explorer view controller.
    var initialDirectoryURL: URL = URL.documentDirectory

    /// A Boolean value indicating whether the user is allowed to remove files.
    var canRemoveFiles: Bool = true

    /// A Boolean value indicating whether the user is allowed to remove directories.
    var canRemoveDirectories: Bool = true

    /// A Boolean value indicating whether the user is allowed to choose files.
    var canChooseFiles: Bool = true

    /// A Boolean value indicating whether the user is allowed to choose directories.
    var canChooseDirectories: Bool = false

    /// A Boolean value indicating whether multiple files and/or directories can be choosen at a time.
    var allowsMultipleSelection: Bool = true

    /// Filters that determine which files are displayed by file explorer view controller.
    ///
    /// Results of multiple filters are combined and displayed by file explorer view controller. All files are displayed if `fileFilters` array is empty.
    var fileFilters = [Filter]()

    /// Filters that determine which files aren't displayed by file explorer view controller.
    ///
    /// Results of multiple filters are combined and all of them aren't displayed by file explorer view controller. All files passing filters from `fileFilters` property are displayed if there are no filters in `ignoredFileFilters` array.
    var ignoredFileFilters = [Filter]()

    /// The file explorer's delegate object.
    weak var delegate: FileExplorerViewControllerDelegate?

    /// File specification providers that are used by file explorer view controller to present thumbnails and view controllers of files of specified type.
    ///
    /// FileExplorer combines these providers with the default ones and uses resulting set of providers to present thumbnails and view controllers of files of specified type. Providers provided by the user have higher priority than the default ones.
    var fileSpecificationProviders: [FileSpecificationProvider.Type]
    private var coordinator: ItemPresentationCoordinator!

    /// Initializes and returns a new file explorer view controller that presents content of directory at specified URL and uses passed file specification providers.
    ///
    /// - Parameters:
    ///   - directoryURL: The URL of directory which is initialy presented by file explorer view controller.
    ///   - providers: Specification providers that allows to extend set of files that are recognized by file explorer view controller. Each instance of file explorer view controller uses default set of providers to recognizer basic set of file formats.
    init(directoryURL: URL = Foundation.URL.documentDirectory,
         providers: [FileSpecificationProvider.Type] = [FileSpecificationProvider.Type]()) {
        self.fileSpecificationProviders = providers
        self.initialDirectoryURL = directoryURL
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        self.fileSpecificationProviders = []
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white

        let navigationController = UINavigationController()
        addContentChildViewController(navigationController)
        coordinator = ItemPresentationCoordinator(navigationController: navigationController)
        coordinator.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let fileSpecifications = FileSpecifications(providers: fileSpecificationProviders)

        let actionsConfiguration = ActionsConfiguration(canRemoveFiles: canRemoveFiles,
                                                        canRemoveDirectories: canRemoveDirectories,
                                                        canChooseFiles: canChooseFiles,
                                                        canChooseDirectories: canChooseDirectories,
                                                        allowsMultipleSelection: allowsMultipleSelection)
        let filteringConfiguration = FilteringConfiguration(fileFilters: fileFilters, ignoredFileFilters: ignoredFileFilters)
        let configuration = Configuration(actionsConfiguration: actionsConfiguration, filteringConfiguration: filteringConfiguration)

        if let item = Item<Any>.at(initialDirectoryURL, isDirectory: true) {
            coordinator.start(item: item, fileSpecifications: fileSpecifications, configuration: configuration, animated: false)
        } else {
            precondition(false, "Passed URL is incorrect.")
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator.stop(false)
    }
}

extension FileExplorerViewController: ItemPresentationCoordinatorDelegate {
    func itemPresentationCoordinatorDidFinish(_ coordinator: ItemPresentationCoordinator) {
        dismiss(animated: true, completion: nil)
        delegate?.fileExplorerViewControllerDidFinish(self)
    }

    func itemPresentationCoordinator(_ coordinator: ItemPresentationCoordinator, didChooseItems items: [Item<Any>]) {
        dismiss(animated: true, completion: nil)
        let urls = items.map { $0.url }
        delegate?.fileExplorerViewController(self, didChooseURLs: urls)
    }
}
