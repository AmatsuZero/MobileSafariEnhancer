//
//  UISearchBarExtensions.swift
//  FileSharer
//
//  Created by modao on 2018/2/6.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit

extension UISearchBar {
    @nonobjc static var kDimmingView = "dimmingView"

    var dimmingView: UIView? {
        get {
            return objc_getAssociatedObject(self, &UISearchBar.kDimmingView) as? UIView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &UISearchBar.kDimmingView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var isEnabled: Bool {
        get {
            return dimmingView != nil
        }
        set(newValue) {
            if newValue {
                dimmingView?.removeFromSuperview()
                dimmingView = nil
            } else {
                let dimmingView = UIView(frame: bounds)
                dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.15)
                addSubview(dimmingView)
                self.dimmingView = dimmingView
            }
            isUserInteractionEnabled = newValue
        }
    }
}
