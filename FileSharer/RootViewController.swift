//
//  RootViewController.swift
//  FileSharer
//
//  Created by modao on 2018/2/3.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit
import SnapKit

@objc(RootViewController)
class RootViewController: UIViewController {

    private let rootViewController = MainViewController()
    private let contentView = UIView()
    private var headerView: HeaderView!

    override func beginRequest(with context: NSExtensionContext) {
        super.beginRequest(with: context)
        Store.createStore(context: context)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    fileprivate func configureUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.addSubview(contentView)
        contentView.layer.cornerRadius = 7
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.borderOpacity.cgColor
        contentView.layer.masksToBounds = true
        contentView.snp.makeConstraints { maker in
            maker.left.equalTo(10)
            maker.right.equalTo(-10)
            maker.center.equalToSuperview()
            maker.height.equalTo(0)
        }

        headerView = HeaderView {
            self.cancelAction()
        }
        contentView.addSubview(headerView)
        headerView.snp.makeConstraints { maker in
            maker.left.right.top.equalToSuperview()
            maker.height.equalTo(0)
        }
        contentView.addSubview(rootViewController.view)
        rootViewController.view.snp.makeConstraints { maker in
            maker.left.right.equalTo(headerView)
            maker.top.equalTo(headerView.snp.bottom)
            maker.bottom.equalToSuperview()
        }
        addChildViewController(rootViewController)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.setNeedsLayout()
        UIView.animate(withDuration: animDuration) {
            self.headerView.snp.updateConstraints({ maker in
                maker.height.equalTo(60)
            })
            self.contentView.snp.updateConstraints { maker in
                maker.height.equalTo(screenHeight - 50*2)
            }
            self.view.layoutIfNeeded()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        cancelAction()
    }
}

extension RootViewController {
    func cancelAction() {
        view.setNeedsLayout()
        UIView.animate(withDuration: animDuration, animations: {
            self.headerView.snp.updateConstraints({ maker in
                maker.height.equalTo(0)
            })
            self.contentView.snp.updateConstraints { maker in
                maker.height.equalTo(0)
            }
            self.view.layoutIfNeeded()
        }) { _ in
            self.extensionContext?.cancelRequest(withError: TaskError.cancel(userInfo: nil).instance)
        }
    }
}
