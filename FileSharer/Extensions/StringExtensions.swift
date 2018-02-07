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

    ///字符串转换成日期
    func converStringToDate(format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }

    ///文件大小转换成可读字符串
    static func fileSizeToString(fileSize: Int64) -> String {
        let KB:Int64 = 1024
        let MB = KB * KB
        let GB = MB * MB

        if fileSize < 10 {
            return "0 B"
        } else if fileSize < KB {
            return "< 1 KB"
        } else if fileSize < MB {
            return String(format: "%.1f KB", Float(fileSize/KB))
        } else if fileSize < GB {
            return String(format: "%.1f MB", Float(fileSize/MB))
        } else {
            return String(format: "%.1f GB", Float(fileSize/GB))
        }
    }

    ///指定路径文件大小
    func getFileSize() throws -> UInt64  {
        var size: UInt64 = 0
        let fileManager = FileManager.default
        var isDir: ObjCBool = false
        let isExists = fileManager.fileExists(atPath: self, isDirectory: &isDir)
        // 判断文件存在
        if isExists {
            // 是否为文件夹
            if isDir.boolValue {
                // 迭代器 存放文件夹下的所有文件名
                let enumerator = fileManager.enumerator(atPath: self)
                for subPath in enumerator! {
                    // 获得全路径
                    let fullPath = appending("/\(subPath)")
                    let attr = try fileManager.attributesOfItem(atPath: fullPath)
                    size += attr[FileAttributeKey.size] as! UInt64
                }
            } else { // 单文件
                let attr = try fileManager.attributesOfItem(atPath: self)
                size += attr[FileAttributeKey.size] as! UInt64
            }
        }
        return size
    }

    func cookie(domain: String? = nil) -> HTTPCookie? {
        let props = components(separatedBy: ";")
            .map { cookieKVString -> (key: String, value: String)? in
                //找出第一个"="号的位置
                if let separatorRange = cookieKVString.range(of: "="),
                    separatorRange.lowerBound != cookieKVString.startIndex, //以上条件确保"="前后都有内容，不至于key或者value为空
                    separatorRange.upperBound != cookieKVString.endIndex {
                    let key = cookieKVString[cookieKVString.startIndex..<separatorRange.lowerBound].trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
                    let value = cookieKVString[separatorRange.upperBound..<cookieKVString.endIndex].trimmingCharacters(in: .whitespacesAndNewlines)
                    return (key: key, value: value)
                }
                return nil
            }
            .compactMap { $0 }
            .reduce([HTTPCookiePropertyKey: Any]()) { (props, pair) -> [HTTPCookiePropertyKey: Any] in
                let (key, value) = pair
                var newProps = props
                switch key {
                case "DOMAIN":
                    newProps[HTTPCookiePropertyKey.domain] = !key.hasPrefix(".") && !value.hasPrefix("www") ? ".\(value)" : value
                case "VERSION":
                    newProps[HTTPCookiePropertyKey.version] = value
                case "MAX-AGE", "MAXAGE":
                    newProps[HTTPCookiePropertyKey.maximumAge] = value
                case "PATH":
                    newProps[HTTPCookiePropertyKey.path] = value
                case "ORIGINURL":
                    newProps[HTTPCookiePropertyKey.originURL] = value
                case "PORT":
                    newProps[HTTPCookiePropertyKey.port] = value
                case "SECURE", "ISSECURE":
                    newProps[HTTPCookiePropertyKey.secure] = value
                case "COMMENT":
                    newProps[HTTPCookiePropertyKey.comment] = value
                case "COMMENTURL":
                    newProps[HTTPCookiePropertyKey.commentURL] = value
                case "EXPIRES":
                    if let date = value.converStringToDate(format: "EEE, dd-MMM-yyyy HH:mm:ss zzz") {
                        newProps[HTTPCookiePropertyKey.expires] = date
                    }
                case "DISCART":
                    newProps[HTTPCookiePropertyKey.discard] = value
                case "NAME":
                    newProps[HTTPCookiePropertyKey.name] = value
                case "VALUE":
                    newProps[HTTPCookiePropertyKey.value] = value
                default:
                    newProps[HTTPCookiePropertyKey.name] = key
                    newProps[HTTPCookiePropertyKey.value] = value
                }
                 //由于cookieWithProperties:方法properties中不能没有NSHTTPCookiePath，所以这边需要确认下，如果没有则默认为@"/"
                if newProps[HTTPCookiePropertyKey.path] == nil {
                    newProps[HTTPCookiePropertyKey.path] = "/"
                }
                if newProps[HTTPCookiePropertyKey.domain] == nil, let host = domain {
                    newProps[HTTPCookiePropertyKey.domain] = host
                }
                return newProps
            }
            return HTTPCookie(properties: props)
    }
}
