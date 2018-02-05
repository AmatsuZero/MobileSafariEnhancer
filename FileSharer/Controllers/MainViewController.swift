//
//  MainViewController.swift
//  FileSharer
//
//  Created by modao on 2018/2/3.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class MainViewController: TabmanViewController {

    private var controllers: [BaseNavigationController] = {
        return [
            BaseNavigationController(rootViewController: CreateTaskViewController()),
            BaseNavigationController(rootViewController: TaskListTableViewController())
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        bar.style = .buttonBar
        bar.location = .top
        automaticallyAdjustsChildViewInsets = true
        bar.appearance = TabmanBar.Appearance({ appearance in
            appearance.state.selectedColor = .yellowTheme
            appearance.text.font = .boldSystemFont(ofSize: 14)
            appearance.indicator.isProgressive = false
            appearance.indicator.bounces = true
            appearance.indicator.color = .yellowTheme
            appearance.layout.extendBackgroundEdgeInsets = true
            appearance.state.color = .lightGray
            appearance.style.background = .solid(color: .theme)
        })
        bar.items = [
            Item(title: "新任务"),
            Item(title: "任务列表")
        ]
        view.backgroundColor = .white
    }
}

extension MainViewController: PageboyViewControllerDataSource {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return controllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return controllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
