//
//  UIViewControllerExtensions.swift
//  FileSharer
//
//  Created by modao on 2018/2/6.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import SnapKit

extension UIViewController {
    @nonobjc static var kActivityIndicatorKey = "fer_activityIndicatorView"
    var activityIndicatorView: UIActivityIndicatorView? {
        get {
            return objc_getAssociatedObject(self, &UIViewController.kActivityIndicatorKey) as? UIActivityIndicatorView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &UIViewController.kActivityIndicatorKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    func showLoadingIndicator() {
        guard self.activityIndicatorView == nil else { return }
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicatorView.color = .gray
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        activityIndicatorView.autoresizingMask = [.flexibleTopMargin,
                                                  .flexibleLeftMargin,
                                                  .flexibleBottomMargin,
                                                  .flexibleRightMargin]
        view.addSubview(activityIndicatorView)
        self.activityIndicatorView = activityIndicatorView
        activityIndicatorView.startAnimating()
    }
    func hideLoadingIndicator() {
        self.activityIndicatorView?.stopAnimating()
        UIView.animate(withDuration: 0.2, animations: {
            self.activityIndicatorView?.alpha = 0.0
        }) { _ in
            self.activityIndicatorView?.removeFromSuperview()
            self.activityIndicatorView = nil
        }
    }
}

extension UIViewController {
    var activeRightBarButtonItem: UIBarButtonItem? {
        get {
            return activeNavigationItem?.rightBarButtonItem
        }

        set(newValue) {
            navigationItem.rightBarButtonItem = newValue
            activeNavigationItem?.rightBarButtonItem = newValue
        }
    }

    var activeNavigationItemTitle: String? {
        get {
            return activeNavigationItem?.title
        }
        set(newValue) {
            navigationItem.title = newValue
            activeNavigationItem?.title = newValue
        }
    }

    var activeNavigationItem: UINavigationItem? {
        guard let viewController = navigationController?.topViewController else { return nil }
        if viewController.navigationItem === navigationItem {
            return navigationItem
        } else {
            return parent?.activeNavigationItem
        }
    }
}

extension UIViewController {
    func addContentChildViewController(_ content: UIViewController,
                                       insets: UIEdgeInsets = UIEdgeInsets.zero) {
        view.addSubview(content.view)
        addChildViewController(content)
        content.view.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(insets)
        }
        content.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        content.didMove(toParentViewController: self)
    }
}
