//
//  UIColor+Hex.swift
//  Move
//
//  Created by bankiiee on 3/9/20.
//

import UIKit

/// https://medium.com/@akshay.s.somkuwar/extension-for-uicolor-swift-5-4c0c15d87ef1
extension UIColor {
    convenience init(rgb: UInt) {
        self.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgb & 0x0000FF) / 255.0, alpha: CGFloat(1.0))
    }
}
