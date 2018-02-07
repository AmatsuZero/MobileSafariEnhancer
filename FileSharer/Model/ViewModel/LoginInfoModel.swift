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
import PromiseKit

class LoginInfoModel {

    let userTextField = UITextField()
    let passwordTextField = UITextField()
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

    func initializeFillText(server: String, protocal: String) {
        getLastLoginInfo(server: server, protocol: protocal).then { info -> Void in
            if let user = info?.user, let pwd = info?.password {
                self.userTextField.text = user
                self.passwordTextField.text = pwd
            } else {
                self.userTextField.placeholder = "输入\(server)注册邮箱"
                self.passwordTextField.placeholder = "输入\(server)密码"
            }
        }
    }

    func saveToKeychain() {
//        if let user = userTextField.text, let pwd = passwordTextField.text {
//            try? keychain?.set(pwd, key: user)
//        }
    }

    var isSaveable: Bool {
        get {
            return userTextField.text?.isEmpty == false && passwordTextField.text?.isEmpty == false
        }
    }

    func getLastLoginInfo(server: String, protocol scheme: String) -> Promise<(user: String, password: String)?> {
        return Promise { resolve, reject in
            DispatchQueue.global().async {
                if let lastLoggedUser = UserDefaults.standard.array(forKey: server)?.first as? String {
                    let chain = Keychain(server: server,
                                         protocolType: ProtocolType(rawValue: scheme) ?? .https)
                    do {
                        let pwd = try chain.getString(lastLoggedUser) ?? ""
                        resolve((user: lastLoggedUser, password: pwd))
                    } catch(let e) {
                        reject(e)
                    }
                } else {
                    resolve(nil)
                }
            }
        }
    }
}
