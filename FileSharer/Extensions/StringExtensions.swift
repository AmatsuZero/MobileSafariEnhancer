 //
//  StringExtensions.swift
//  FileSharer
//
//  Created by modao on 2018/2/6.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import Foundation

extension String {
    func searchEd2kName() -> String {
        let strClearArray = components(separatedBy: "|")
        guard strClearArray.count > 2 else {
            return self
        }
        if let name = strClearArray[2].removingPercentEncoding {
            return name
        }
        return self
    }
}
