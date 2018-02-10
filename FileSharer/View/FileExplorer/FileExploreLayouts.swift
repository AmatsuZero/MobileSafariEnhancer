//
//  FileExploreLayouts.swift
//  FileSharer
//
//  Created by modao on 2018/2/9.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit

// SB = Mockingbot
private let SectionBackground = "FileExplorerCollectionReusableView"

protocol FileExplorerCollectionViewDelegateFlowLayout: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor
}

extension FileExplorerCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        return UIColor.clear
    }
}

private class FileExplorerCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    var isBottomRound = false
    var backgroundColor = UIColor.clear
    var space:CGFloat = 0
    var showBottomLine = false
}

private class FileExplorerCollectionReusableView: UICollectionReusableView {

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        guard let attr = layoutAttributes as? FileExplorerCollectionViewLayoutAttributes else {
            return
        }
        self.backgroundColor = attr.backgroundColor
        if attr.isBottomRound {
            let maskPath = UIBezierPath(roundedRect: CGRect(x: 0,
                                                            y: 0,
                                                            width: contentWidth-2*attr.space,
                                                            height: attr.frame.height),
                                        byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight],
                                        cornerRadii: CGSize(width: 10, height: 10))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = attr.bounds
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer
        }

        //添加分割线
        if attr.showBottomLine {
            let bottomBorder = UIView()
            bottomBorder.backgroundColor = .borderOpacity
            addSubview(bottomBorder)
            bottomBorder.snp.makeConstraints { maker in
                maker.right.left.bottom.equalToSuperview()
                maker.height.equalTo(1)
            }
        }
    }
}

private class FileExplorerColllectionSeparator: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .borderOpacity
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        frame = layoutAttributes.frame
    }
}

class FileExplorerCollectionViewFlowLayout: UICollectionViewFlowLayout {

    private var decorationViewAttrs: [UICollectionViewLayoutAttributes] = []

    // MARK: - Init
    override init() {
        super.init()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    // MARK: - Setup

    func setup() {
        // 1、注册
        register(FileExplorerCollectionReusableView.classForCoder(), forDecorationViewOfKind: SectionBackground)
    }

    // MARK: -
    override func prepare() {
        super.prepare()

        guard let numberOfSections = self.collectionView?.numberOfSections,
            let delegate = self.collectionView?.delegate as? FileExplorerCollectionViewDelegateFlowLayout
            else {
                return
        }

        self.decorationViewAttrs.removeAll()
        for section in 0..<numberOfSections {
            guard let numberOfItems = self.collectionView?.numberOfItems(inSection: section),
                numberOfItems > 0,
                let firstItem = self.layoutAttributesForItem(at: IndexPath(item: 0, section: section)),
                let lastItem = self.layoutAttributesForItem(at: IndexPath(item: numberOfItems - 1, section: section)) else {
                    continue
            }
            var sectionInset = self.sectionInset
            if let inset = delegate.collectionView?(self.collectionView!, layout: self, insetForSectionAt: section) {
                sectionInset = inset
            }
            var sectionFrame = firstItem.frame.union(lastItem.frame)
            sectionFrame.origin.x = 0
            sectionFrame.origin.y -= sectionInset.top
            if self.scrollDirection == .horizontal {
                sectionFrame.size.width += sectionInset.left + sectionInset.right
                sectionFrame.size.height = self.collectionView!.frame.height
            } else {
                sectionFrame.size.width = self.collectionView!.frame.width
                sectionFrame.size.height += sectionInset.top + sectionInset.bottom
            }
            // 2、定义
            let attr = FileExplorerCollectionViewLayoutAttributes(forDecorationViewOfKind: SectionBackground,
                                                                  with: IndexPath(item: 0, section: section))
            attr.frame = sectionFrame
            attr.zIndex = -1
            attr.space = 10
            attr.backgroundColor = delegate.collectionView(self.collectionView!,
                                                           layout: self,
                                                           backgroundColorForSectionAt: section)
            //定义圆角遮罩
            //            attr.isBottomRound = section == numberOfSections - 1
            //定义分割线
            attr.showBottomLine = section != numberOfSections - 1
            self.decorationViewAttrs.append(attr)
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attrs = super.layoutAttributesForElements(in: rect)
        attrs?.append(contentsOf: self.decorationViewAttrs.filter {
            return rect.intersects($0.frame)
        })
        return attrs // 3、返回
    }
}
