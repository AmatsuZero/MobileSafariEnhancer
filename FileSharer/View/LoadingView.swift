//
//  LoadingView.swift
//  FileSharer
//
//  Created by modao on 2018/2/4.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit
import SnapKit
import DGActivityIndicatorView

class LoadingView: UIView {

    private let activityIndicatorView = DGActivityIndicatorView(type: .ballSpinFadeLoader,
                                                                tintColor: .yellowTheme)

    override init(frame: CGRect) {
        super.init(frame: frame)
        alpha = 0
        backgroundColor = .theme
        addSubview(activityIndicatorView!)
        activityIndicatorView?.snp.makeConstraints({ maker in
            maker.center.equalToSuperview()
        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func display(fromView: UIView,
                 animated: Bool = true,
                 customConstraint: ((ConstraintMaker) -> Void)? = nil,
                 completionHandler: (() -> Void)? = nil)  {
        fromView.addSubview(self)
        fromView.setNeedsLayout()
        if let constraint = customConstraint {
            snp.makeConstraints(constraint)
        } else {
            snp.makeConstraints { maker in
                maker.edges.equalToSuperview()
            }
        }
        fromView.layoutIfNeeded()
        if animated {
            UIView.animate(withDuration: animDuration, animations: {
                self.alpha = 1
            }) { _ in
                completionHandler?()
            }
        } else {
            alpha = 1
        }
        activityIndicatorView?.startAnimating()
    }

    func hide(animated: Bool, completionHandler: (() -> Void)? = nil)  {
        if animated {
            UIView.animate(withDuration: animDuration,
                           delay: 0.5,
                           options: .curveEaseIn, animations: {
                self.alpha = 0
            }) { _ in
                self.activityIndicatorView?.stopAnimating()
                completionHandler?()
                self.removeFromSuperview()
            }
        } else {
            self.activityIndicatorView?.stopAnimating()
            alpha = 0
            completionHandler?()
            removeFromSuperview()
        }
    }
}
