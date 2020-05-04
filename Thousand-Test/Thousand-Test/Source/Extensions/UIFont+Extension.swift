//
//  UIFont+Extension.swift
//  Thousand-Test
//
//  Created by Aibol Tungatarov on 5/3/20.
//  Copyright © 2020 Aibol Tungatarov. All rights reserved.
//

import UIKit

extension UIFont {
    static func medium(size: CGFloat = 27) -> UIFont? {
        let font = UIFont(name: "Arial-BoldMT", size: size)
        return font
    }
    
    static func light(size: CGFloat = 18) -> UIFont? {
        let font = UIFont(name: "ArialMT", size: size)
        return font
    }
}
