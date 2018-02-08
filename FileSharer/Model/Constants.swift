//
//  Constants.swift
//  FileSharer
//
//  Created by modao on 2018/2/3.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit

let screenHeight = UIScreen.main.bounds.height
let screenWidth = UIScreen.main.bounds.width
let animDuration = 0.3
let verticalPadding: CGFloat = 50
let horizontalPadding: CGFloat = 10
let contentWidth = screenWidth - horizontalPadding*2
let contentHeight = screenHeight - verticalPadding*2

let factorWidth: (CGFloat) -> CGFloat = { width -> CGFloat in
    return (width*contentWidth)/(375-horizontalPadding*2)
}

let factorHeight: (CGFloat) -> CGFloat = { height -> CGFloat in
    return (height*contentHeight)/(667-horizontalPadding*2)
}
let grounpIdentifier = "group.daubert.safarienhancer"
