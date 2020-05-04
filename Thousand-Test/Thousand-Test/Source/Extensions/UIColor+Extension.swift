//
//  UIColor+Extension.swift
//  Thousand-Test
//
//  Created by Aibol Tungatarov on 5/3/20.
//  Copyright © 2020 Aibol Tungatarov. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(red: Int, green: Int, blue: Int, alpha: Int) -> UIColor {
        return UIColor(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: CGFloat(alpha))
    }
}

extension UIColor {
    static let customOrange = UIColor.rgb(red: 249, green: 101, blue: 0, alpha: 1)
    static let backgroundColor = UIColor.rgb(red: 29, green: 29, blue: 37, alpha: 1)
    static let customGray = UIColor.rgb(red: 151, green: 151, blue: 163, alpha: 1)
    static let kinoPoisk = UIColor.rgb(red: 234, green: 161, blue: 44, alpha: 1)
    static let tmdb = UIColor.rgb(red: 84, green: 139, blue: 208, alpha: 1)
    static let kinokz = UIColor.rgb(red: 223, green: 104, blue: 36, alpha: 1)
    static let commentColor = UIColor.rgb(red: 153, green: 153, blue: 164, alpha: 1)
    static let buttonColor = UIColor.rgb(red: 83, green: 84, blue: 106, alpha: 1)
}
