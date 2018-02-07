//
//  DirectoryContentViewControllerExtensions.swift
//  FileSharer
//
//  Created by modao on 2018/2/7.
//  Copyright © 2018年 MockingBot. All rights reserved.
//
import DZNEmptyDataSet

extension DirectoryContentViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "PlaceHolder")
    }

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Please Allow Photo Access"
        let attr = [
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18),
            NSAttributedStringKey.foregroundColor: UIColor.darkGray
        ]
        return NSAttributedString(string: text, attributes: attr)
    }

    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "This allows you to share photos from your library and save photos to your camera roll."
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        let attrs = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),
            NSAttributedStringKey.foregroundColor: UIColor.lightGray,
            NSAttributedStringKey.paragraphStyle: paragraph
        ]
        return NSAttributedString(string: text, attributes: attrs)
    }

    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let attr = [
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 17)
        ]
        return NSAttributedString(string: "Continue", attributes: attr)
    }

    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return .white
    }
}
