//
//  CheckmarkButton.swift
//  FileSharer
//
//  Created by modao on 2018/2/6.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit

final class CheckmarkButton: UIButton {
    let shapeLayer = CAShapeLayer()
    private enum KeyPath {
        static let strokeEnd = "strokeEnd"
        static let backgroundColor = "backgroundColor"
    }

    override init(frame: CGRect) {
        shapeLayer.contentsScale = UIScreen.main.scale
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.strokeEnd = 0.0
        shapeLayer.backgroundColor = UIColor.white.cgColor
        shapeLayer.actions = [
            KeyPath.strokeEnd: NSNull(),
            KeyPath.backgroundColor: NSNull()
        ]
        super.init(frame: frame)
        layer.addSublayer(shapeLayer)
        layer.masksToBounds = true
        borderColor = ColorPallete.gray
        isSelected = false
        addTarget(self, action: #selector(handleTouchUpInside), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 22.0, height: 22.0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width/2.0
        shapeLayer.frame = bounds.insetBy(dx: borderWidth, dy: borderWidth)
        shapeLayer.cornerRadius = shapeLayer.bounds.width/2.0
        shapeLayer.path = UIBezierPath.makeCheckmarkPath(with: shapeLayer.bounds.insetBy(dx: 3.5, dy: 4.5)).cgPath
    }

    private var borderColor: UIColor? {
        get {
            return backgroundColor
        }
        set(newValue) {
            backgroundColor = newValue
        }
    }

    var borderWidth: CGFloat = 1.0 {
        didSet {
            setNeedsLayout()
        }
    }

    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set(newValue) {
            setSelected(newValue, animated: false)
        }
    }

    func setSelected(_ selected: Bool, animated: Bool) {
        if isSelected == selected {
            return
        }
        super.isSelected = selected
        CATransaction.begin()
        CATransaction.setAnimationDuration(animated ? 0.2 : 0.0)
        defer {
            CATransaction.commit()
        }
        if selected {
            shapeLayer.animate(keyPath: KeyPath.strokeEnd, to: NSNumber(value: 1.0))
            shapeLayer.animate(keyPath: KeyPath.backgroundColor, to: ColorPallete.blue.cgColor)
            borderColor = UIColor.white
        } else {
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.0)
            shapeLayer.animate(keyPath: KeyPath.strokeEnd, to: NSNumber(value: 0.0), duration: 0.0)
            CATransaction.commit()
            shapeLayer.animate(keyPath: KeyPath.backgroundColor, to: UIColor.white.cgColor)
            borderColor = ColorPallete.gray
        }
    }

    @objc private func handleTouchUpInside() {
        let newIsSelected = !self.isSelected
        setSelected(newIsSelected, animated: true)
    }
}

extension CALayer {
    @discardableResult
    func animate(keyPath: String, from fromValue: AnyObject? = nil, to toValue: AnyObject, duration: Double = 0.2) -> CAAnimation? {
        guard fromValue !== toValue else {
            return nil
        }
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.fromValue = value(forKey: keyPath)
        animation.toValue = toValue
        animation.duration = duration
        add(animation, forKey: keyPath)
        setValue(toValue, forKey: keyPath)
        return animation
    }
}
