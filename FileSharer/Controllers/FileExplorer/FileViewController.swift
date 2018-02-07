//
//  FileViewController.swift
//  FileSharer
//
//  Created by modao on 2018/2/7.
//  Copyright © 2018年 MockingBot. All rights reserved.
//
import UIKit
import SnapKit

final class FileViewController: UIViewController {
    private let viewModel: FileViewModel
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()

    init(viewModel: FileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        extendedLayoutIncludesOpaqueBars = false
        edgesForExtendedLayout = []

        let imageView = ImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        let titleView = TitleView()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.title = viewModel.title
        titleView.setContentCompressionResistancePriority(.required, for: .vertical)
        titleView.setContentCompressionResistancePriority(.required, for: .horizontal)


        let attributesView = AttributesView()
        attributesView.translatesAutoresizingMaskIntoConstraints = false
        attributesView.numberOfAttributes = viewModel.numberOfAttributes
        attributesView.setContentCompressionResistancePriority(.required, for: .vertical)
        attributesView.setContentCompressionResistancePriority(.required, for: .horizontal)
        for (index, label) in attributesView.attributeNamesColumn.labels.enumerated() {
            let attributeViewModel = viewModel.attribute(for: index)
            label.text = attributeViewModel.attributeName
        }
        for (index, label) in attributesView.attributeValuesColumn.labels.enumerated() {
            let attributeViewModel = viewModel.attribute(for: index)
            label.text = attributeViewModel.attributeValue
        }

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleView)
        stackView.addArrangedSubview(attributesView)
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.addSubview(stackView)
        view.setNeedsLayout()
        stackView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.width.height.equalTo(view)
        }
        
        activeNavigationItemTitle = viewModel.title
        view.layoutIfNeeded()
        imageView.customImage = viewModel.thumbnailImage(with: CGSize(width: imageView.bounds.width,
                                                                      height: imageView.bounds.height))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        scrollView.contentSize = view.bounds.size
        stackView.frame = CGRect(origin: CGPoint.zero, size: view.bounds.size)
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
