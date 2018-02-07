//
//  UnknownFileTypeViewController.swift
//  FileSharer
//
//  Created by modao on 2018/2/6.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import SnapKit

final class UknownFileTypeViewController: UIViewController {
    let fileName: String
    var imageView: UIImageView = UIImageView()

    init(fileName: String) {
        self.fileName = fileName
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        setUpImageView()
        setUpTextLabel()
    }

    private func setUpImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = ImageAssets.genericDocumentIcon
        view.addSubview(imageView)
        imageView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().offset(70)
            maker.trailing.equalToSuperview().offset(-70)
            maker.height.equalTo(imageView.snp.width).multipliedBy(1)
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().offset(-50)
        }
    }

    private func setUpTextLabel() {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 23.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = fileName
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        view.addSubview(label)
        label.snp.makeConstraints { maker in
            maker.top.equalTo(imageView.snp.bottom).offset(20)
            maker.leading.equalToSuperview().offset(20)
            maker.trailing.equalToSuperview().offset(-20)
        }
    }
}
