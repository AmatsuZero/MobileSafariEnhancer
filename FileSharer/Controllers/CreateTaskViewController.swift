//
//  CreateTaskViewController.swift
//  FileSharer
//
//  Created by modao on 2018/2/3.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit

class CreateTaskViewController: UIViewController {

    let createTaskView = CreateTaskView(frame: .zero)
    private lazy var fileExplorer: FileExplorerViewController = {
        let fevc = FileExplorerViewController(directoryURL: Store.shared.groupContainerURL ?? .documentDirectory)
        return fevc
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
        present(fileExplorer, animated: true) {

        }
    }
}
