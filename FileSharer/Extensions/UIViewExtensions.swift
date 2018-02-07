//
//  UIViewExtensions.swift
//  FileSharer
//
//  Created by modao on 2018/2/6.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import SnapKit

extension UIView {
    
    @discardableResult
    func pinToBottom(of view: UIView) -> Constraint {
        var constraint: Constraint!
        snp.makeConstraints { maker in
            constraint = maker.bottom.equalTo(view).constraint
            maker.leading.equalTo(view)
            maker.height.equalTo(self.bounds.height)
        }
        return constraint
    }
    func edges(equalTo view: UIView, insets: UIEdgeInsets = UIEdgeInsets.zero) {
        snp.makeConstraints { maker in
            maker.leading.equalTo(view).offset(insets.left)
            maker.trailing.equalTo(view).offset(insets.right)
            maker.top.equalTo(view).offset(insets.top)
            maker.bottom.equalTo(view).offset(insets.bottom)

        }
    }
}
