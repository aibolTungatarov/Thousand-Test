//
//  HeaderView.swift
//  Thousand-Test
//
//  Created by Aibol Tungatarov on 5/3/20.
//  Copyright © 2020 Aibol Tungatarov. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.medium(size: 25)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = .clear
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
    }

}
