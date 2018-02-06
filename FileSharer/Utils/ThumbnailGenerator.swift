//
//  ThumbnailGenerator.swift
//  FileSharer
//
//  Created by modao on 2018/2/6.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit
import ImageIO
import AVFoundation

protocol ThumbnailGenerator {
    func generate(size: CGSize) -> UIImage?
}

final class ImageThumbnailGenerator: ThumbnailGenerator {
    private let url: URL

    init(url: URL) {
        self.url = url
    }

    func generate(size: CGSize) -> UIImage? {
        guard let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil) else {
            return nil
        }

        let options: [NSString: Any] = [
            kCGImageSourceThumbnailMaxPixelSize: Double(max(size.width, size.height) * UIScreen.main.scale),
            kCGImageSourceCreateThumbnailFromImageIfAbsent: true
        ]

        return CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as NSDictionary).flatMap { UIImage(cgImage: $0) }
    }
}

final class BorderDecorator: ThumbnailGenerator {
    private let color: UIColor
    private let thumbnailGenerator: ThumbnailGenerator
    private let borderWidth: CGFloat

    init(thumbnailGenerator: ThumbnailGenerator,
         color: UIColor = ColorPallete.gray,
         borderWidth: CGFloat = 1.0/UIScreen.main.scale) {
        self.color = color
        self.thumbnailGenerator = thumbnailGenerator
        self.borderWidth = borderWidth
    }

    func generate(size: CGSize) -> UIImage? {
        guard size.width >= 2 && size.height >= 2 else { return nil }
        guard let contentImage = self.thumbnailGenerator.generate(size: CGSize(width: size.width - 2*borderWidth, height: size.height - 2*borderWidth)),
            let cgContentImage = contentImage.cgImage else { return nil }

        var rect = AVMakeRect(aspectRatio: contentImage.size, insideRect: CGRect(origin: CGPoint.zero, size: size))
        rect.origin = CGPoint.zero
        rect.size.width = round(rect.width)
        rect.size.height = round(rect.height)

        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        defer { UIGraphicsEndImageContext() }

        context.setFillColor(color.cgColor)
        context.fill(rect)
        context.translateBy(x: 0, y: rect.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.draw(cgContentImage, in: rect.insetBy(dx: borderWidth, dy: borderWidth))

        return context.makeImage().flatMap { UIImage(cgImage: $0, scale: UIScreen.main.scale, orientation: .up) }
    }
}

final class StaticImageThumbnailGenerator: ThumbnailGenerator {
    private let image: UIImage

    init(image: UIImage) {
        self.image = image
    }

    func generate(size: CGSize) -> UIImage? {
        return image
    }
}

final class VideoThumbnailGenerator: ThumbnailGenerator {
    private let url: URL

    init(url: URL) {
        self.url = url
    }

    func generate(size: CGSize) -> UIImage? {
        let scale = UIScreen.main.scale
        let asset = AVURLAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.maximumSize = CGSize(width: size.width * scale, height: size.height * scale)

        let kPreferredTimescale: Int32 = 1000
        var actualTime: CMTime = CMTime(seconds: 0, preferredTimescale: kPreferredTimescale)
        //generates thumbnail at first second of the video
        let cgImage = try? generator.copyCGImage(at: CMTime(seconds: 1, preferredTimescale: kPreferredTimescale), actualTime: &actualTime)
        return cgImage.flatMap { UIImage(cgImage: $0, scale: scale, orientation: .up) }
    }
}

final class PDFThumbnailGenerator: ThumbnailGenerator {
    private let url: URL

    init(url: URL) {
        self.url = url
    }
    func generate(size: CGSize) -> UIImage? {
        guard let document = CGPDFDocument(url as CFURL), let page = document.page(at: 1) else { return nil }
        let originalPageRect: CGRect = page.getBoxRect(.mediaBox)
        var targetPageRect = AVMakeRect(aspectRatio: originalPageRect.size, insideRect: CGRect(origin: CGPoint.zero, size: size))
        targetPageRect.origin = .zero

        UIGraphicsBeginImageContextWithOptions(targetPageRect.size, true, 0)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(gray: 1.0, alpha: 1.0)
        context.fill(targetPageRect)
        context.saveGState()
        context.translateBy(x: 0.0, y: targetPageRect.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.concatenate(page.getDrawingTransform(.mediaBox, rect: targetPageRect, rotate: 0, preserveAspectRatio: true))
        context.drawPDFPage(page)
        context.restoreGState()
        return context.makeImage().flatMap { UIImage(cgImage: $0, scale: UIScreen.main.scale, orientation: .up) }
    }
}
