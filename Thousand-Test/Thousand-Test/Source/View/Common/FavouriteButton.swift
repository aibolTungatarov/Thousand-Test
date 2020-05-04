//
//  FavouriteButton.swift
//  Thousand-Test
//
//  Created by Aibol Tungatarov on 5/3/20.
//  Copyright © 2020 Aibol Tungatarov. All rights reserved.
//

import UIKit

class FavouriteButton: UIButton {
    let isFavouriteImg = UIImage(named: "liked")
    let isNotFavouriteImg = UIImage(named: "not_liked")?.maskWithColor(color: .white)
    var isFavourite: Bool? {
        didSet {
            guard let isFavourite = isFavourite else { return }
            if isFavourite {
                self.setImage(isFavouriteImg, for: .normal)
            }else {
                self.setImage(isNotFavouriteImg, for: .normal)
            }
        }
    }
}
