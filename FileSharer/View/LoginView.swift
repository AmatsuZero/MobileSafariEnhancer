//
//  LoginView.swift
//  FileSharer
//
//  Created by modao on 2018/2/4.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit

class LoginView: UIView {

    private let imgLogin = UIImageView(image: #imageLiteral(resourceName: "owl-login.png"))
    private let imgLeftHand = UIImageView(image: #imageLiteral(resourceName: "owl-login-arm-left.png"))
    private let imgLeftHandGone = UIImageView(image: #imageLiteral(resourceName: "owl-hand.png"))
    private let imgRightHand = UIImageView(image: #imageLiteral(resourceName: "owl-login-arm-right.png"))
    private let imgRightHandGone = UIImageView(image: #imageLiteral(resourceName: "owl-hand.png"))
    private let vLogin = UIView()
    private let button = UIButton(type: .custom)
    fileprivate let offsetLeftHand = factorWidth(60)
    var saveHandler: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .theme
        imgLogin.layer.masksToBounds = true

        imgLogin.frame = CGRect(x: contentWidth/2 - factorWidth(211/2),
                                y: 0,
                                width: factorWidth(211),
                                height: factorHeight(109))
        addSubview(imgLogin)

        vLogin.layer.borderWidth = 1
        vLogin.layer.cornerRadius = 7
        vLogin.layer.borderColor = UIColor.white.cgColor
        vLogin.layer.backgroundColor = UIColor.lightTheme.cgColor
        vLogin.frame = CGRect(x: factorWidth(15),
                              y: imgLogin.frame.maxY - 8,
                              width: contentWidth - factorWidth(30),
                              height: factorHeight(160))
        addSubview(vLogin)

        imgLeftHand.frame = CGRect(x: factorWidth(61) - offsetLeftHand,
                                   y: factorHeight(90),
                                   width: factorWidth(40),
                                   height: factorHeight(65))
        imgLogin.addSubview(imgLeftHand)

        imgLeftHandGone.frame = CGRect(x: contentWidth/2 - factorWidth(100),
                                       y: vLogin.frame.minY - factorHeight(20),
                                       width: factorWidth(40),
                                       height: factorHeight(40))
        addSubview(imgLeftHandGone)

        imgRightHand.frame = CGRect(x: imgLogin.frame.width/2 + factorWidth(60),
                                    y: factorHeight(90),
                                    width: factorWidth(40),
                                    height: factorHeight(65))
        imgLogin.addSubview(imgRightHand)

        imgRightHandGone.frame = CGRect(x: contentWidth/2 + factorWidth(62),
                                        y: vLogin.frame.minY - factorHeight(20),
                                        width: factorWidth(40),
                                        height: factorHeight(40))
        addSubview(imgRightHandGone)

        let padding: CGFloat = (160-44*2)/3
        Store.shared.loginInfoModel.userTextField.delegate = self
        Store.shared.loginInfoModel.userTextField.frame = CGRect(x: factorWidth(30),
                                                                 y: factorHeight(padding),
                                                                 width: vLogin.frame.width - factorWidth(60),
                                                                 height: factorHeight(44))
        vLogin.addSubview(Store.shared.loginInfoModel.userTextField)

        Store.shared.loginInfoModel.passwordTextField.delegate = self
        Store.shared.loginInfoModel.passwordTextField.frame = CGRect(x: factorWidth(30),
                                                                     y: Store.shared.loginInfoModel.userTextField.frame.maxY + factorHeight(padding),
                                                                     width: vLogin.frame.width - factorWidth(60),
                                                                     height: factorHeight(44))

        button.setTitle("保存", for: .normal)
        button.layer.cornerRadius = 7
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.backgroundColor = .gray
        button.frame = CGRect(x: 0,
                              y: vLogin.frame.maxY + 14,
                              width: vLogin.frame.width,
                              height: factorHeight(44))
        button.center.x = vLogin.center.x
        addSubview(button)
        button.addTarget(self,
                         action: #selector(LoginView.save(sender:)),
                         for: .touchUpInside)
        vLogin.addSubview(Store.shared.loginInfoModel.passwordTextField)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func save(sender: UIButton?) {
        endEditing(true)
        Store.shared.loginInfoModel.saveToKeychain()
        if let hander = saveHandler {
            hander()
        }
    }
}

extension LoginView: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.yellowTheme.cgColor
        if textField.tag == 1 {
            if let imageView = textField.leftView?.subviews.first as? UIImageView {
                imageView.image = UIImage.fontAwesomeIcon(name: .user,
                                                          textColor: .yellowTheme,
                                                          size: CGSize(width: 22, height: 22))
                Store.shared.loginInfoModel.passwordTextField.layer.borderColor = UIColor.white.cgColor
            }
            guard Store.shared.loginInfoModel.showType == .PASS else {
                Store.shared.loginInfoModel.showType = .USER
                return
            }
            Store.shared.loginInfoModel.showType = .USER
            UIView.animate(withDuration: 0.5) {
                self.imgLeftHand.frame.origin.x -= self.offsetLeftHand
                self.imgLeftHand.frame.origin.y += factorHeight(30)
                self.imgRightHand.frame.origin.x += factorWidth(48)
                self.imgRightHand.frame.origin.y += factorHeight(30)
                self.imgLeftHandGone.frame.origin.x -= factorWidth(70)
                self.imgLeftHandGone.alpha = 1
                self.imgRightHandGone.frame.origin.x += factorWidth(62)
                self.imgRightHandGone.alpha = 1
            }
        } else {
            if let imageView = textField.leftView?.subviews.first as? UIImageView {
                imageView.image = UIImage.fontAwesomeIcon(name: .lock,
                                                          textColor: .yellowTheme,
                                                          size: CGSize(width: 22, height: 22))
                Store.shared.loginInfoModel.userTextField.layer.borderColor = UIColor.white.cgColor
            }
            guard Store.shared.loginInfoModel.showType != .PASS else {
                Store.shared.loginInfoModel.showType = .PASS
                return
            }
            Store.shared.loginInfoModel.showType = .PASS
            UIView.animate(withDuration: 0.5) {
                self.imgLeftHand.frame.origin.x += self.offsetLeftHand
                self.imgLeftHand.frame.origin.y -= factorHeight(30)
                self.imgRightHand.frame.origin.x -= factorWidth(48)
                self.imgRightHand.frame.origin.y -= factorHeight(30)
                self.imgLeftHandGone.frame.origin.x += factorWidth(70)
                self.imgLeftHandGone.alpha = 0
                self.imgRightHandGone.frame.origin.x -= factorWidth(62)
                self.imgRightHandGone.alpha = 0
            }
        }
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        button.backgroundColor = Store.shared.loginInfoModel.isSaveable ? .yellowTheme : .gray
        button.isEnabled = Store.shared.loginInfoModel.isSaveable
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if textField.tag == 1, let imageView = textField.leftView?.subviews.first as? UIImageView {
            imageView.image = UIImage.fontAwesomeIcon(name: .user,
                                                      textColor: .white,
                                                      size: CGSize(width: 22, height: 22))
        } else if textField.tag == 2, let imageView = textField.leftView?.subviews.first as? UIImageView {
            imageView.image = UIImage.fontAwesomeIcon(name: .lock,
                                                      textColor: .white,
                                                      size: CGSize(width: 22, height: 22))
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            Store.shared.loginInfoModel.passwordTextField.becomeFirstResponder()
            return true
        }
        guard Store.shared.loginInfoModel.isSaveable else {
            return false
        }
        save(sender: nil)
        return true
    }
}
