//
//  CreateTaskViewController.swift
//  FileSharer
//
//  Created by modao on 2018/2/3.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit

class CreateTaskViewController: UIViewController {

    private let presentTransitionDelegate = EXModalTransitionExtensionDelegate()

    let createTaskView = CreateTaskView(frame: .zero)
    private lazy var fileExplorer: FileExplorerViewController? = {
        if let downloadedURL = Store.shared.groupContainerURL?.appendingPathComponent("Downloaded") {
            let feevc = FileExplorerViewController(directoryURL: downloadedURL)
            feevc.delegate = self
            feevc.transitioningDelegate = presentTransitionDelegate
            feevc.modalPresentationStyle = .custom
            return feevc
        }
        return nil
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(createTaskView)
        createTaskView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        let testBtn = UIButton()
        createTaskView.addSubview(testBtn)
        testBtn.setTitle("测试", for: .normal)
        testBtn.backgroundColor = .yellowTheme
        testBtn.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.width.equalTo(100)
            maker.height.equalTo(100)
        }
        testBtn.addTarget(self, action: #selector(CreateTaskViewController.test), for: .touchUpInside)
    }

    @objc func test() {
        if let vc = fileExplorer {
            present(vc, animated: true) {

            }
        }
    }
}

extension CreateTaskViewController: FileExplorerViewControllerDelegate {
    
    func fileExplorerViewControllerDidFinish(_ controller: FileExplorerViewController) {

    }

    func fileExplorerViewController(_ controller: FileExplorerViewController, didChooseURLs urls: [URL]) {

    }
}
