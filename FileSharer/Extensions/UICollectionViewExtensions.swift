//
//  UICollectionViewExtensions.swift
//  FileSharer
//
//  Created by modao on 2018/2/6.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit

extension UICollectionView {
    func registerCell(ofClass cellClass: AnyClass) {
        register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass))
    }

    func dequeueReusableCell<T: UICollectionViewCell>(ofClass cellClass: AnyClass, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: cellClass), for: indexPath) as? T else {
            let stringDescribingCellClass = String(describing: cellClass)
            fatalError("Cell with class \(stringDescribingCellClass) can't be dequeued")
        }
        if let editableCell = cell as? Editable {
            editableCell.setEditing(isEditing, animated: false)
        }
        return cell
    }

    func registerFooter(ofClass viewClass: AnyClass) {
        register(viewClass, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: String(describing: viewClass))
    }

    func dequeueReusableFooter<T: UICollectionReusableView>(ofClass cellClass: AnyClass, for indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: String(describing: cellClass), for: indexPath) as! T
    }

    func registerHeader(ofClass viewClass: AnyClass) {
        register(viewClass, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: viewClass))
    }

    func dequeueReusableHeader<T: UICollectionReusableView>(ofClass cellClass: AnyClass, for indexPath: IndexPath) -> T {
        return dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: cellClass), for: indexPath) as! T
    }

    func header<T: UICollectionReusableView>(for indexPath: IndexPath) -> T? {
        return supplementaryView(forElementKind: UICollectionElementKindSectionHeader, at: indexPath) as? T
    }
}

extension UICollectionView {
    @nonobjc static var kIsEditingKey = "isEditing"
    @nonobjc static var kToolbarKey = "toolbar"
    @nonobjc static var kToolbarBottomConstraint = "bottomConstraint"

    var isEditing: Bool {
        get {
            return (objc_getAssociatedObject(self, &UICollectionView.kIsEditingKey) as? NSNumber)?.boolValue ?? false
        }
        set(newValue) {
            setEditing(newValue, animated: false)
        }
    }

    var toolbar: UIToolbar? {
        get {
            return (objc_getAssociatedObject(self, &UICollectionView.kToolbarKey)) as? UIToolbar
        }
        set(newValue) {
            objc_setAssociatedObject(self, &UICollectionView.kToolbarKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }

    private var toolbarBottomConstraint: NSLayoutConstraint? {
        get {
            return (objc_getAssociatedObject(self, &UICollectionView.kToolbarBottomConstraint)) as? NSLayoutConstraint
        }
        set(newValue) {
            objc_setAssociatedObject(self, &UICollectionView.kToolbarBottomConstraint, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }

    func setEditing(_ editing: Bool, animated: Bool) {
        for cell in visibleCells {
            guard let cell = cell as? Editable else {
                continue
            }
            cell.setEditing(editing, animated: animated)
        }

        objc_setAssociatedObject(self, &UICollectionView.kIsEditingKey, NSNumber(value: editing), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
