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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(createTaskView)
        createTaskView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
}
