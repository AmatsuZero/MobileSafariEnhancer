//
//  UIToolbarExtensions.swift
//  FileSharer
//
//  Created by modao on 2018/2/6.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit

extension UIToolbar {
    static func makeToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.sizeToFit()
        return toolbar
    }
}
