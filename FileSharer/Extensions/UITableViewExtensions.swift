//
//  UITableViewExtensions.swift
//  FileSharer
//
//  Created by modao on 2018/2/6.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit

extension UITableView {
    func registerCell(ofClass cellClass: AnyClass) {
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
    }
    func dequeueReusableCell<T: UITableViewCell>(ofClass cellClass: AnyClass) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: cellClass)) as? T else {
            let stringDescribingCellClass = String(describing: cellClass)
            fatalError("Cell with class \(stringDescribingCellClass) can't be dequeued")
        }
        return cell
    }
    func makeCell(with style: UITableViewCellStyle) -> UITableViewCell {
        return UITableViewCell(style: style, reuseIdentifier: String(describing: UITableViewCell.self))
    }
}
