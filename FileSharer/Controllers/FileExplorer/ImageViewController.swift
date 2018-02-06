//
//  ImageViewController.swift
//  FileSharer
//
//  Created by modao on 2018/2/6.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit

final class ImageViewController: UIViewController {
    fileprivate var scrollView: UIScrollView!
    fileprivate var imageView: UIImageView!
    private let image: UIImage
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        let scrollView = UIScrollView()
        self.scrollView = scrollView
        self.view = scrollView

        let imageView = UIImageView(image: image)
        imageView.frame = view.bounds
        imageView.contentMode = .scaleAspectFit
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.imageView = imageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        extendedLayoutIncludesOpaqueBars = false
        edgesForExtendedLayout = []

        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2
        scrollView.delegate = self
        scrollView.addSubview(imageView)
    }

    fileprivate func centerImageView() {
        var vertical: CGFloat = 0, horizontal: CGFloat = 0
        if scrollView.contentSize.width < view.bounds.width {
            horizontal = (scrollView.bounds.width - scrollView.contentSize.width)/2
        }
        if scrollView.contentSize.height < view.bounds.height {
            vertical = (scrollView.bounds.height - scrollView.contentSize.height)/2
        }
        scrollView.contentInset = UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImageView()
    }
}
