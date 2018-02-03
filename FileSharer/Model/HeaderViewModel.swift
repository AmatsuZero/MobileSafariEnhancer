//
//  HeaderViewModel.swift
//  FileSharer
//
//  Created by modao on 2018/2/3.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit
import SDWebImage

class HeaderViewModel {
    let favicon = UIImageView(image: UIImage(named: "favicons"))
    let titleLable = UILabel()
    var imageURL: URL? {
        didSet {
            if let url = imageURL {
                favicon.sd_setImage(with: url, completed: nil)
            }
        }
    }
    init() {
        titleLable.text = "未知"
        titleLable.textColor = .lightText
        titleLable.font = .systemFont(ofSize: 10)
        titleLable.textAlignment = .center
        favicon.contentMode = .center
    }
}
