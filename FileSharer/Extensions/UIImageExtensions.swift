//
//  UIImageExtensions.swift
//  FileSharer
//
//  Created by modao on 2018/2/6.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit

extension UIImage {
    static func make(for name: String, bundle: Bundle = Bundle(for: ItemCell.self)) -> UIImage? {
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
}

extension UIImage {
    static func makeImage(withColor color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        UIGraphicsBeginImageContext(size);
        guard let context = UIGraphicsGetCurrentContext() else { fatalError() }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        guard let cgImage = context.makeImage() else { fatalError() }
        UIGraphicsEndImageContext();
        return UIImage(cgImage: cgImage)
    }
}
