//
//  BezierPathExtensions.swift
//  FileSharer
//
//  Created by modao on 2018/2/6.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit

extension UIBezierPath {
    static func makeCheckmarkPath(with frame: CGRect) -> UIBezierPath {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: frame.minX + 0.07692 * frame.width, y: frame.minY + 0.57143 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.30769 * frame.width, y: frame.minY + 0.85714 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.92308 * frame.width, y: frame.minY + 0.09524 * frame.height))
        bezierPath.lineWidth = 2
        return bezierPath
    }
}
