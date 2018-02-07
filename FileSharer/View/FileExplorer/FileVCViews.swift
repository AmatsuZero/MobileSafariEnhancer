
//
//  FileViewController.swift
//  FileSharer
//
//  Created by modao on 2018/2/7.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit

final class ImageView: UIView {
    private let customImageView: UIImageView
    override init(frame: CGRect) {
        customImageView = UIImageView()
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        super.init(frame: frame)
        addSubview(customImageView)
        customImageView.backgroundColor = .white
        customImageView.contentMode = .scaleAspectFit
        customImageView.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.width.equalTo(-40)
            maker.height.equalTo(-38)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var customImage: UIImage? {
        get {
            return customImageView.image
        }
        set(newValue) {
            customImageView.image = newValue
        }
    }
}

final class TitleView: UIView {
    private let titleLabel: UILabel
    override init(frame: CGRect) {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 23.0)
        super.init(frame: frame)

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalTo(-1.0)
            maker.width.equalTo(-20)
        }
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail

        let topSeparator = SeparatorView()
        topSeparator.translatesAutoresizingMaskIntoConstraints = false
        topSeparator.backgroundColor = ColorPallete.gray
        addSubview(topSeparator)
        topSeparator.snp.makeConstraints { maker in
            maker.leading.trailing.top.equalToSuperview()
        }

        let bottomSeparator = SeparatorView()
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        bottomSeparator.backgroundColor = ColorPallete.gray
        addSubview(bottomSeparator)
        bottomSeparator.snp.makeConstraints { maker in
            maker.leading.trailing.bottom.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var title: String? {
        get {
            return titleLabel.text
        }
        set(newValue) {
            titleLabel.text = newValue
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 42.0)
    }
}

final class AttributesView: UIView {
    private let stackView = UIStackView()
    internal let attributeNamesColumn = AttributesColumnView()
    internal let attributeValuesColumn = AttributesColumnView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        stackView.addArrangedSubview(attributeNamesColumn)
        attributeNamesColumn.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(attributeValuesColumn)
        attributeValuesColumn.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.layoutMargins = UIEdgeInsets(top: 16.0, left: 0, bottom: 17.0, right: 0.0)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.distribution = .fillProportionally
        stackView.spacing = 10.0
        addSubview(stackView)
        stackView.edges(equalTo: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var numberOfAttributes: Int = 0 {
        didSet {
            attributeNamesColumn.numberOfAttributes = numberOfAttributes
            for label in attributeNamesColumn.labels {
                label.translatesAutoresizingMaskIntoConstraints = false
                label.textAlignment = .right
                label.font = UIFont.systemFont(ofSize: 15.0)
                label.textColor = ColorPallete.gray
            }
            attributeValuesColumn.numberOfAttributes = numberOfAttributes
            for label in attributeValuesColumn.labels {
                label.translatesAutoresizingMaskIntoConstraints = false
                label.textAlignment = .left
                label.font = UIFont.systemFont(ofSize: 15.0)
                label.textColor = UIColor.black
            }
        }
    }
}

final class AttributesColumnView: UIView {
    var labels = [UILabel]()
    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10.0
        addSubview(stackView)
        stackView.edges(equalTo: self)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var numberOfAttributes: Int = 0 {
        didSet {
            labels.forEach { label in
                stackView.removeArrangedSubview(label)
                label.removeFromSuperview()
            }
            labels.removeAll()
            for _ in 0..<numberOfAttributes {
                let label = UILabel()
                labels.append(label)
                stackView.addArrangedSubview(label)
            }
        }
    }
}
