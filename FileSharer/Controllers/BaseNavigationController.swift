//
//  BaseNavigationController.swift
//  FileSharer
//
//  Created by modao on 2018/2/3.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.clipsToBounds = true
        navigationBar.barTintColor = .theme
        navigationBar.isTranslucent = false
        navigationBar.tintColor = .white
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        view.endEditing(true)
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        view.endEditing(true)
        return super.popViewController(animated: animated)
    }
}
