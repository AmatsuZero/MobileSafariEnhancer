//
//  UIViewExtensions.swift
//  FileSharer
//
//  Created by modao on 2018/2/6.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit
import SnapKit

extension UIView {
    @discardableResult
    func pinToBottom(of view: UIView) -> NSLayoutConstraint {
        let constraint = bottomAnchor.constraint(equalTo: view.bottomAnchor)
        constraint.isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        heightAnchor.constraint(equalToConstant: self.bounds.height).isActive = true
        return constraint
    }
    func edges(equalTo view: UIView, insets: UIEdgeInsets = UIEdgeInsets.zero) {
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: insets.right).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom).isActive = true
    }
    @discardableResult
    func pinToBottom(of view: UIView, insets: UIEdgeInsets = UIEdgeInsets.zero) -> Constraint {
        var constraint: Constraint!
        snp.makeConstraints { maker in
            constraint = maker.bottom.equalTo(view).constraint
            maker.leading.equalTo(view)
            maker.height.equalTo(self.bounds.height)
        }
        return constraint
    }
    func snpEdges(equalTo view: UIView, insets: UIEdgeInsets = UIEdgeInsets.zero)  {
        snp.makeConstraints { maker in
            maker.leading.equalTo(view).offset(insets.left)
            maker.trailing.equalTo(view).offset(insets.right)
            maker.top.equalTo(view).offset(insets.top)
            maker.bottom.equalTo(view).offset(insets.bottom)

        }
    }
}
