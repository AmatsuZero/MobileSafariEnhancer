//
//  UIColorExtensions.swift
//  FileSharer
//
//  Created by modao on 2018/2/3.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit

extension UIColor {
    open class var theme: UIColor {
        return UIColor(red: 15/255, green: 15/255, blue: 15/255, alpha: 1)
    }
    open class var lightTheme: UIColor {
        return UIColor(red: 28/255, green: 28/255, blue: 28/255, alpha: 1)
    }
    open class var yellowTheme: UIColor {
        return UIColor(red: 1, green: 153/255, blue: 0, alpha: 1)
    }
    open class var borderOpacity: UIColor {
        return UIColor.black.withAlphaComponent(0.10)
    }
    open class var background: UIColor {
        return UIColor.black.withAlphaComponent(0.7)
    }
}
