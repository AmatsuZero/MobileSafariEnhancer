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
    let favicon = UIImageView(image: #imageLiteral(resourceName: "favicons.png"))
    let titleLable = UILabel()

    func setValue(imageURL: URL, address: String) {
        DispatchQueue.main.async { [weak self] in
            self?.favicon.sd_setImage(with: imageURL, completed: nil)
            self?.titleLable.text = address
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
