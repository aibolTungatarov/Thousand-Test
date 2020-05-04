//
//  RateDetailCell.swift
//  Thousand-Test
//
//  Created by Aibol Tungatarov on 5/3/20.
//  Copyright © 2020 Aibol Tungatarov. All rights reserved.
//

import UIKit

class RateDetailCell: UITableViewCell {
    
    // MARK: - Properties
    var isSet: Bool?
    
    var overview: String? {
        didSet {
            descriptionLabel.text = overview
        }
    }
    
    var rateTMDB: Double? {
        didSet {
            setupStackView()
        }
    }
    
    // MARK: - Views
    fileprivate var descriptionLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont.light()
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate var rateReviwLabel: UILabel = {
        let label = UILabel()
        label.text = "Ratings and overviews"
        label.font = UIFont.medium(size: 23)
        label.textColor = .white
        return label
    }()
    
    fileprivate var rateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - ConfigUI
extension RateDetailCell {
    fileprivate func configUI() {
        backgroundColor = .clear
        [descriptionLabel, rateReviwLabel, rateStackView].forEach {
            addSubview($0)
        }
        makeConstraints()
    }
    
    fileprivate func makeConstraints() {
        descriptionLabel.snp.makeConstraints { (m) in
            m.left.equalToSuperview().offset(20)
            m.right.equalToSuperview().offset(-20)
            m.top.equalToSuperview().offset(20)
        }
        
        rateReviwLabel.snp.makeConstraints { (m) in
            m.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            m.right.left.equalTo(descriptionLabel)
        }
        
        rateStackView.snp.makeConstraints { (m) in
            m.top.equalTo(rateReviwLabel.snp.bottom).offset(20)
            m.right.equalTo(rateReviwLabel).offset(-20)
            m.left.equalTo(rateReviwLabel).offset(20)
            m.height.equalTo(70)
            m.bottom.equalToSuperview().offset(-10).priority(.high)
        }
    }
    
    fileprivate func setupStackView() {
        if !(isSet ?? false) {
            for i in 0...2 {
                let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 70, height: 70)))
                let rateLabel = UILabel()
                rateLabel.textAlignment = .center
                rateLabel.textColor = .white
                rateLabel.font = UIFont.medium()
                rateLabel.contentMode = .top
                let nameLabel = UILabel()
                nameLabel.textAlignment = .center
                nameLabel.font = UIFont.light(size: 16)
                nameLabel.contentMode = .bottom
                if i == 1 {
                    nameLabel.textColor = UIColor.tmdb
                    nameLabel.text = "TMDB"
                    if let rateTMDB = rateTMDB {
                        rateLabel.text = String(rateTMDB)
                    }
                }else {
                    if i == 0 {
                        nameLabel.textColor = UIColor.kinokz
                        nameLabel.text = "Kino.kz"
                    }else {
                        nameLabel.textColor = UIColor.kinoPoisk
                        nameLabel.text = "КиноПоиск"
                    }
                    rateLabel.text = "-"
                }
                [rateLabel, nameLabel].forEach {
                    view.addSubview($0)
                }
                
                nameLabel.snp.makeConstraints { (m) in
                    m.top.left.right.equalToSuperview()
                    m.height.equalTo(40)
                }
                
                rateLabel.snp.makeConstraints { (m) in
                    m.height.equalTo(30)
                    m.top.equalTo(nameLabel.snp.bottom)
                    m.left.right.equalToSuperview()
                }
                rateStackView.addArrangedSubview(view)
            }
        }
        
    }
}
