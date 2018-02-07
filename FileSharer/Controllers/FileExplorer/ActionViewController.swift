//
//  ActionViewController.swift
//  FileSharer
//
//  Created by modao on 2018/2/7.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit

protocol ActionsViewControllerDelegate: class {
    func actionsViewControllerDidRequestRemoval(_ controller: ActionsViewController)
    func actionsViewControllerDidRequestShare(_ controller: ActionsViewController)
}

final class ActionsViewController: UIViewController {
    weak var delegate: ActionsViewControllerDelegate?

    private let toolbar = UIToolbar()
    private let contentViewController: UIViewController

    init(contentViewController: UIViewController) {
        self.contentViewController = contentViewController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        extendedLayoutIncludesOpaqueBars = false
        edgesForExtendedLayout = []
        view.addSubview(toolbar)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.sizeToFit()
        toolbar.pinToBottom(of: view)
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .action,
                            target: self,
                            action: #selector(ActionsViewController.handleShareButtonTap)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                            target: self,
                            action: nil),
            UIBarButtonItem(barButtonSystemItem: .trash,
                            target: self,
                            action: #selector(ActionsViewController.handleTrashButtonTap))
        ]
        addContentChildViewController(contentViewController, insets: UIEdgeInsets(top: 0,
                                                                                  left: 0,
                                                                                  bottom: toolbar.bounds.height,
                                                                                  right: 0))
        navigationItem.title = contentViewController.navigationItem.title
    }

    // MARK: Actions
    @objc
    private func handleShareButtonTap() {
        delegate?.actionsViewControllerDidRequestShare(self)
    }

    @objc
    private func handleTrashButtonTap() {
        delegate?.actionsViewControllerDidRequestRemoval(self)
    }
}
