//
//  LoginViewController.swift
//  FileSharer
//
//  Created by modao on 2018/2/4.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {

    private let loginView = LoginView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loginView)
        loginView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        loginView.saveHandler = { 
            self.hide()
        }
        loginView.skipHandler = {
            self.hide()
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(LoginViewController.keyboardWillShow(notification:)),
                                               name: .UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(LoginViewController.keyboardWillHide(notification:)),
                                               name: .UIKeyboardWillHide,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillShow(notification: Notification) {
        if let userInfo = notification.userInfo,
            let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt,
            let contentView = view.superview {
            let frame = value.cgRectValue
            contentView.setNeedsLayout()
            var intersetFrame = frame.intersection(view.frame)
            if intersetFrame.height == 0 {
                intersetFrame = CGRect(x: intersetFrame.minX, y: intersetFrame.minY, width: intersetFrame.width, height: 100)
            }
            UIView.animate(withDuration: duration, delay: 0.0,
                           options: UIViewAnimationOptions(rawValue: curve),
                           animations: {
                           contentView.snp.updateConstraints{ maker in
                                maker.centerY.equalToSuperview().offset(-intersetFrame.height - 20)
                            }
                            contentView.layoutIfNeeded()
            }, completion: nil)
        }
    }

    @objc func keyboardWillHide(notification :Notification) {
        if let userInfo = notification.userInfo,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt,
            let contentView = view.superview {
            contentView.setNeedsLayout()
            UIView.animate(withDuration: duration, delay: 0.0,
                           options: UIViewAnimationOptions(rawValue: curve),
                           animations: {
                            contentView.snp.updateConstraints{ maker in
                                maker.centerY.equalToSuperview().offset(0)
                            }
                            contentView.layoutIfNeeded()
            }, completion: nil)
        }
    }

    func hide() {
        view.superview?.setNeedsLayout()
        UIView.animate(withDuration: animDuration, animations: {
            self.view.alpha = 0
            self.view.superview?.layoutIfNeeded()
        }) { _ in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
    }
}
