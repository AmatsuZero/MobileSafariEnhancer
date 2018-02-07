//
//  ErrorViewController.swift
//  FileSharer
//
//  Created by modao on 2018/2/7.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit
import SnapKit

protocol ErrorViewControllerDelegate: class {
    func errorViewControllerDidFinish(_ controller: ErrorViewController)
}

final class ErrorViewController: UIViewController {
    weak var delegate: ErrorViewControllerDelegate?

    private let errorDescription: String
    private let finishButtonHidden: Bool

    init(errorDescription: String, finishButtonHidden: Bool) {
        self.errorDescription = errorDescription
        self.finishButtonHidden = finishButtonHidden
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = errorDescription
        label.sizeToFit()
        view.addSubview(label)
        view.snp.makeConstraints { maker in
            maker.center.equalTo(label)
        }

        if !finishButtonHidden {
            let barButtonItem = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""),
                                                style: .plain,
                                                target: self,
                                                action: #selector(ErrorViewController.handleFinishButtonTap))
            navigationItem.leftBarButtonItem = barButtonItem
        }
    }

    // MARK: Actions
    @objc func handleFinishButtonTap() {
        delegate?.errorViewControllerDidFinish(self)
    }
}
