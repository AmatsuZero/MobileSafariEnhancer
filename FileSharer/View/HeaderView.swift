//
//  HeaderView.swift
//  FileSharer
//
//  Created by modao on 2018/2/3.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit
import SnapKit

class HeaderView: UIView {

    private let cancelActionHandler: (() -> Void)
    private let settingActionHandler: (() -> Void)
    private let headerModle = Store.shared.headerModel
    private let cancelButton = UIButton(type: .custom)
    private let settingButton = UIButton(type: .custom)

    init(cancelAction: @escaping (() -> Void), settingAction: @escaping (() -> Void)) {
        cancelActionHandler = cancelAction
        settingActionHandler = settingAction
        super.init(frame: .zero)
        configureUI()
        cancelButton.addTarget(self,
                               action: #selector(HeaderView.save(sender:)),
                               for: .touchUpInside)
        settingButton.addTarget(self,
                                action: #selector(HeaderView.setting(sender:)),
                                for: .touchUpInside)
    }

    private func configureUI() {
        backgroundColor = .theme
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 14)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.sizeToFit()
        addSubview(cancelButton)
        cancelButton.snp.makeConstraints { maker in
            maker.left.equalTo(18)
            maker.centerY.equalToSuperview()
        }
        addSubview(headerModle.favicon)
        headerModle.favicon.snp.makeConstraints { maker in
            maker.width.height.equalTo(16)
            maker.centerX.equalToSuperview()
            maker.top.equalTo(8)
        }
        addSubview(headerModle.titleLable)
        headerModle.titleLable.snp.makeConstraints { maker in
            maker.top.equalTo(headerModle.favicon.snp.bottom).offset(4)
            maker.centerX.equalToSuperview()
        }

        addSubview(settingButton)
        settingButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 16)
        settingButton.setTitle(String.fontAwesomeIcon(name: .gear), for: .normal)
        settingButton.snp.makeConstraints { maker in
            maker.right.equalTo(-18)
            maker.centerY.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func save(sender: UIButton?)  {
        cancelActionHandler()
    }

    @objc func setting(sender: UIButton?) {
        cancelActionHandler()
    }
}
