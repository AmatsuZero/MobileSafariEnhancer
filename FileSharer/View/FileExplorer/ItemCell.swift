//
//  ItemCell.swift
//  FileSharer
//
//  Created by modao on 2018/2/6.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit
import SnapKit

protocol Editable {
    func setEditing(_ editing: Bool, animated: Bool)
}

enum ColorPallete {
    static let gray = UIColor(red: 200/255.0, green: 199/255.0, blue: 204/255.0, alpha: 1.0)
    static let blue = UIColor(red: 21/255.0, green: 126/255.0, blue: 251/255, alpha: 1.0)
}

enum LayoutConstants {
    static let separatorLeftInset: CGFloat = 22.0
    static let iconWidth: CGFloat = 44.0
}

final class ItemCell: UICollectionViewCell, Editable {
    enum AccessoryType {
        case detailButton
        case disclosureIndicator
    }
    private lazy var accessoryImageViewTapRecognizer: UITapGestureRecognizer = {
        let gez = UITapGestureRecognizer(target: self, action: #selector(ItemCell.handleAccessoryImageTap))
        gez.delegate = self
        return gez
    }()
    private let containerView = UIView()
    private let separatorView = SeparatorView()
    private let iconImageView = UIImageView()
    private let titleTextLabel = UILabel()
    private let subtitleTextLabel = UILabel()
    private let accessoryImageView = UIImageView()
    private var customAccessoryType = AccessoryType.detailButton
    private let checkmarkButton = CheckmarkButton()

    var tapAction: () -> Void = {}

    override init(frame: CGRect) {
        containerView.backgroundColor = .white
        separatorView.backgroundColor = ColorPallete.gray
        iconImageView.contentMode = .scaleAspectFit
        titleTextLabel.numberOfLines = 1
        titleTextLabel.lineBreakMode = .byTruncatingMiddle
        titleTextLabel.font = UIFont.systemFont(ofSize: 17)
        subtitleTextLabel.numberOfLines = 1
        subtitleTextLabel.lineBreakMode = .byTruncatingMiddle
        subtitleTextLabel.font = .systemFont(ofSize: 12)
        subtitleTextLabel.textColor = .gray
        accessoryImageView.contentMode = .center
        super.init(frame: frame)
        backgroundColor = UIColor.white
        accessoryImageView.addGestureRecognizer(accessoryImageViewTapRecognizer)
        accessoryImageView.isUserInteractionEnabled = true
        setupContainerViewConstraints()
        setupSeparatorViewConstraints()
        setupIconImageViewConstraints()
        setupAccessoryImageViewConstraints()
        setupTitleLabelContstraints()
        setupSubtitleLabelConstraints()
        setupCheckmarkButtonConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupContainerViewConstraints() {
        addSubview(containerView)
        containerView.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview()
            maker.trailing.equalTo(0)
            maker.leading.equalTo(0)
        }
    }

    private func setupSeparatorViewConstraints() {
        containerView.addSubview(separatorView)
        separatorView.snp.makeConstraints { maker in
            maker.leading.equalTo(LayoutConstants.separatorLeftInset)
            maker.trailing.bottom.equalToSuperview()
        }
    }

    private func setupIconImageViewConstraints() {
        containerView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { maker in
            maker.leading.equalTo(24)
            maker.width.equalTo(LayoutConstants.iconWidth)
            maker.top.equalTo(10)
            maker.bottom.equalTo(-10)
        }
    }

    private func setupAccessoryImageViewConstraints() {
        containerView.addSubview(accessoryImageView)
        accessoryImageView.snp.makeConstraints { maker in
            maker.trailing.equalTo(-15)
            maker.centerY.equalToSuperview()
        }
        accessoryImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        accessoryImageView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        accessoryImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

    private func setupTitleLabelContstraints() {
        containerView.addSubview(titleTextLabel)
        titleTextLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(iconImageView.snp.trailing).offset(12)
            maker.trailing.equalTo(accessoryImageView.snp.leading).offset(-10)
            maker.top.equalTo(12)
        }
        titleTextLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        titleTextLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }

    private func setupSubtitleLabelConstraints() {
        containerView.addSubview(subtitleTextLabel)
        subtitleTextLabel.snp.makeConstraints { maker in
            maker.leading.trailing.equalTo(titleTextLabel)
            maker.top.equalTo(titleTextLabel.snp.bottom).offset(3)
        }
        subtitleTextLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        subtitleTextLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }

    private func setupCheckmarkButtonConstraints() {
        addSubview(checkmarkButton)
        checkmarkButton.snp.makeConstraints { maker in
            maker.trailing.equalTo(containerView.snp.leading).offset(-4)
            maker.centerY.equalToSuperview().offset(1)
        }
    }

    var title: String? {
        get {
            return titleTextLabel.text
        }
        set(newValue) {
            titleTextLabel.text = newValue
        }
    }

    var subtitle: String? {
        get {
            return subtitleTextLabel.text
        }
        set(newValue) {
            subtitleTextLabel.text = newValue
        }
    }

    var iconImage: UIImage? {
        get {
            return iconImageView.image
        }
        set(newValue) {
            iconImageView.image = newValue
        }
    }

    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set(newValue) {
            super.isSelected = newValue
            checkmarkButton.setSelected(newValue, animated: UIView.areAnimationsEnabled)
            setNeedsLayout()
        }
    }

    var isEditing: Bool = false {
        didSet {
            containerView.snp.updateConstraints { maker in
                maker.leading.equalTo(isEditing ? 38.0 : 0.0)
                maker.trailing.equalTo(isEditing ? 38.0 : 0.0)
            }
            setNeedsLayout()
        }
    }

    func setEditing(_ editing: Bool, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.isEditing = editing
                self.layoutIfNeeded()
            }
        } else {
            self.isEditing = editing
        }
    }

    var accessoryType: AccessoryType {
        get {
            return customAccessoryType
        }
        set(newValue) {
            customAccessoryType = newValue
            switch customAccessoryType {
            case .detailButton:
                accessoryImageView.image = .make(for: "DetailButtonImage")
                accessoryImageViewTapRecognizer.isEnabled = true
            case .disclosureIndicator:
                accessoryImageView.image = .make(for: "DisclosureButtonImage")
                accessoryImageViewTapRecognizer.isEnabled = false
            }
            setNeedsLayout()
        }
    }

    var maximumIconSize: CGSize {
        let max = Swift.max(Swift.max(iconImageView.frame.width, iconImageView.frame.height), LayoutConstants.iconWidth)
        return CGSize(width: max, height: max)
    }

    // MARK: Actions
    @objc func handleAccessoryImageTap() {
        tapAction()
    }
}

extension ItemCell: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

final class CollectionViewHeader: UICollectionReusableView {
    private let segmentedControl: UISegmentedControl
    var sortModeChangeAction: (SortMode) -> Void = { _ in }

    override init(frame: CGRect) {
        segmentedControl = UISegmentedControl(items: ["Name", "Date"])
        super.init(frame: frame)
        segmentedControl.sizeToFit()
        segmentedControl.frame.size = CGSize(width: 160.0, height: segmentedControl.bounds.height)
        segmentedControl.autoresizingMask = []
        segmentedControl.addTarget(self, action: #selector(CollectionViewHeader.handleSegmentedControlValueChanged), for: .valueChanged)
        addSubview(segmentedControl)
        sortMode = .name
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        segmentedControl.center = CGPoint(x: bounds.midX, y: bounds.midY)
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
        separators.forEach({addSubview($0)})
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
