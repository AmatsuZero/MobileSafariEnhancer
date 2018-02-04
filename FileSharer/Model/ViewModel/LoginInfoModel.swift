//
//  LoginInfoModel.swift
//  FileSharer
//
//  Created by modao on 2018/2/4.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit
import KeychainAccess
import FontAwesome_swift

class LoginInfoModel {

    let userTextField = UITextField()
    let passwordTextField = UITextField()
    private var keychain: Keychain?
    var showType = ShowType.NONE

    enum ShowType: Int {
        case NONE = 0, USER, PASS
    }

    init() {
        userTextField.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry = true
        userTextField.textContentType = .emailAddress
        passwordTextField.textContentType = .password
        // Configure UI
        userTextField.layer.cornerRadius = 7
        userTextField.layer.borderColor = UIColor.white.cgColor
        userTextField.layer.borderWidth = 1
        userTextField.backgroundColor = .theme
        userTextField.returnKeyType = .next
        userTextField.textColor = .white
        userTextField.font = .systemFont(ofSize: 12)
        userTextField.tintColor = .yellowTheme

        userTextField.leftView = LoginInfoModel.getLeftIcon(type: .user)
        userTextField.tag = 1
        userTextField.leftViewMode = .always

        passwordTextField.layer.cornerRadius = userTextField.layer.cornerRadius
        passwordTextField.layer.borderColor = userTextField.layer.borderColor
        passwordTextField.layer.borderWidth = userTextField.layer.borderWidth
        passwordTextField.textColor = userTextField.textColor
        passwordTextField.font = userTextField.font
        passwordTextField.tintColor = userTextField.tintColor
        passwordTextField.backgroundColor = userTextField.backgroundColor
        passwordTextField.leftViewMode = userTextField.leftViewMode
        passwordTextField.leftView = LoginInfoModel.getLeftIcon(type: .lock)
        passwordTextField.tag = 2
    }

    private class func getLeftIcon(type: FontAwesome) -> UIView {
        let leftViewFrame = CGRect(origin: .zero, size: CGSize(width: 44, height: 44))
        let leftView = UIView(frame: leftViewFrame)
        let leftIcon = UIImageView()
        leftIcon.image = UIImage.fontAwesomeIcon(name: type,
                                                 textColor: .white,
                                                 size: CGSize(width: 22, height: 22))
        leftView.addSubview(leftIcon)
        leftIcon.snp.makeConstraints { maker in
            maker.width.height.equalTo(22)
            maker.center.equalToSuperview()
        }
        return leftView
    }

    func initializeKeychain(server: String, protocal: String) {
        if keychain == nil {
            keychain = Keychain.init(server: server,
                                     protocolType: ProtocolType(rawValue: protocal) ?? .https)
        }
        if let lastLoggedUser = UserDefaults.standard.array(forKey: server)?.first as? String,
            let pwd = try? keychain?.getString(lastLoggedUser) {
            DispatchQueue.main.async {
                self.userTextField.text = lastLoggedUser
                self.passwordTextField.text = pwd
            }
        }
        userTextField.placeholder = "输入\(server)注册邮箱"
        passwordTextField.placeholder = "输入\(server)密码"
    }

    func saveToKeychain() {
        if let user = userTextField.text, let pwd = passwordTextField.text {
          //  try? keychain?.set(pwd, key: user)
        }
    }

    var isSaveable: Bool {
        get {
            return userTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false
        }
    }
}
