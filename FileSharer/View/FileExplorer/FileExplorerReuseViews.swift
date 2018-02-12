//
//  FileExplorerReuseViews.swift
//  FileSharer
//
//  Created by modao on 2018/2/9.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import FontAwesome_swift

final class CollectionViewHeader: UICollectionReusableView {
    private let segmentedControl: FontAwesomeSegmentedControl
    private let displaySegementedControl: FontAwesomeSegmentedControl
    var sortModeChangeAction: (SortMode) -> Void = { _ in }

    override init(frame: CGRect) {
        segmentedControl = FontAwesomeSegmentedControl(items: ["fa-file", "fa-bomb"])
        segmentedControl.tintColor = .yellowTheme
        segmentedControl.layer.borderColor = UIColor.yellowTheme.cgColor
        segmentedControl.prepareForInterfaceBuilder()

        displaySegementedControl = FontAwesomeSegmentedControl(items: ["fa-tasks", "fa-tags"])
        displaySegementedControl.tintColor = .theme
        displaySegementedControl.prepareForInterfaceBuilder()

        super.init(frame: frame)
        segmentedControl.sizeToFit()
        displaySegementedControl.sizeToFit()

        segmentedControl.addTarget(self,
                                   action: #selector(CollectionViewHeader.handleSegmentedControlValueChanged),
                                   for: .valueChanged)
        addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { maker in
            maker.left.equalTo(20)
            maker.width.equalTo(160)
            maker.centerY.equalToSuperview()
        }
        addSubview(displaySegementedControl)
        displaySegementedControl.snp.makeConstraints { maker in
            maker.left.equalTo(segmentedControl.snp.right).offset(20)
            maker.right.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
        sortMode = .name
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var sortMode: SortMode {
        get {
            switch segmentedControl.selectedSegmentIndex {
            case 0: return .name
            case 1: return .date
            default: fatalError()
            }
        }
        set(newValue) {
            switch newValue {
            case .name: segmentedControl.selectedSegmentIndex = 0
            case .date: segmentedControl.selectedSegmentIndex = 1
            }
        }
    }

    @objc
    private func handleSegmentedControlValueChanged() {
        sortModeChangeAction(sortMode)
    }
}

final class CollectionViewFooter: UICollectionReusableView {
    var leftInset: CGFloat = LayoutConstants.separatorLeftInset
    private var separators = [SeparatorView]()

    override init(frame: CGRect) {
        for _ in 0..<15 {
            separators.append(SeparatorView())
        }
        super.init(frame: frame)
        separators.forEach {addSubview($0)}
        tintColor = ColorPallete.gray
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        for (i, separator) in separators.enumerated() {
            let size = CGSize(width: bounds.width - leftInset, height: 1.0)
            separator.frame.size = separator.sizeThatFits(size)
            separator.frame.origin = CGPoint(x: leftInset, y: CGFloat(i+1) * 64.0 - size.height)
        }
    }

    override var tintColor: UIColor! {
        get {
            return super.tintColor
        }
        set(newValue) {
            super.tintColor = newValue
            adjustAfterTintColorChange()
        }
    }

    override func tintColorDidChange() {
        adjustAfterTintColorChange()
    }

    private func adjustAfterTintColorChange() {
        separators.forEach({$0.backgroundColor = tintColor})
    }
}

final class SeparatorView: UIView {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: 1.0/UIScreen.main.scale)
    }
    override var intrinsicContentSize: CGSize {
        return CGSize(width: CGFloat.greatestFiniteMagnitude, height: 1.0/UIScreen.main.scale)
    }
}
