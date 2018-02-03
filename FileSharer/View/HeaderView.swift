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
    private let headerModle = Store.shared.headerModel
    private let cancelButton = UIButton(type: .custom)

    init(cancelAction: @escaping (() -> Void)) {
        cancelActionHandler = cancelAction
        super.init(frame: .zero)
        configureUI()
        cancelButton.addTarget(self,
                               action: #selector(HeaderView.buttonAction(sender:)),
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
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func buttonAction(sender: UIButton?)  {
        cancelActionHandler()
    }
}
