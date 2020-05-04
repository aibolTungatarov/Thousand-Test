//
//  MovieViewCell.swift
//  Thousand-Test
//
//  Created by Aibol Tungatarov on 5/3/20.
//  Copyright © 2020 Aibol Tungatarov. All rights reserved.
//

import UIKit

class MovieViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    var getFullImagePath: ((String)->(String))?
    var getGenreByIdClosure: (([Int])->([String]))?
    
    var movie: Movie? {
        didSet {
            guard let movie = movie else {return}
            if let getFullImagePath = getFullImagePath, let posterPath = movie.poster_path {
                imageString = getFullImagePath(posterPath)
            }
            if let getGenreByIdClosure = getGenreByIdClosure, let genre_ids = movie.genre_ids {
                setupGenreLabels(getGenreByIdClosure(genre_ids))
            }
            title = movie.original_title
            rate = movie.vote_average
        }
    }
    
    // MARK: - Views
    
    fileprivate var verticalLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    fileprivate let gradientContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate var imageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    fileprivate var imageString: String? {
        didSet {
            if let imageString = imageString {imageView.loadImageFromUrl(urlString: imageString)}
        }
    }
    
    fileprivate var containerForLabel: UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.medium()
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    //Might be more than one
    fileprivate var genreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.medium()
        return label
    }()
    
    fileprivate var rateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.medium()
        label.textAlignment = .right
        return label
    }()
    
    fileprivate var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    fileprivate var rate: Double? {
        didSet {
            if let rate = rate {rateLabel.text = String(rate)}
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - ConfigUI
extension MovieViewCell {
    fileprivate func configUI() {
        backgroundColor = .clear
        setupGradientLayer()
        [imageView, gradientContainerView, containerForLabel].forEach {
            addSubview($0)
        }
        
        [titleLabel, rateLabel, verticalLine].forEach {
            containerForLabel.addSubview($0)
        }
        
        makeConstraints()
    }

    
    fileprivate func makeConstraints() {
        imageView.snp.makeConstraints { (m) in
            m.right.left.top.equalToSuperview()
            m.height.equalTo(self.frame.height)
        }
        
        gradientContainerView.snp.makeConstraints { (m) in
            m.right.left.bottom.equalToSuperview()
        }
        
        containerForLabel.snp.makeConstraints { (m) in
            m.right.equalToSuperview().offset(-20)
            m.left.equalToSuperview().offset(20)
            m.bottom.equalToSuperview()
            m.height.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { (m) in
            m.top.left.equalToSuperview()
            m.width.equalTo(containerForLabel.frame.width - 100)
            m.right.equalTo(verticalLine).offset(-30)
        }
        
        rateLabel.snp.makeConstraints { (m) in
            m.right.equalToSuperview()
            m.centerY.equalTo(titleLabel)
            m.width.equalTo(50)
        }
        
        verticalLine.snp.makeConstraints { (m) in
            m.height.equalTo(60)
            m.width.equalTo(2)
            m.centerY.equalTo(rateLabel)
            m.right.equalTo(rateLabel.snp.left)
        }
    }
    
    fileprivate func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.backgroundColor.cgColor]
        gradientLayer.locations = [0.5, 1]
        gradientContainerView.layer.addSublayer(gradientLayer)
        gradientLayer.frame = self.bounds
        gradientLayer.frame.origin.y -= bounds.height
    }
    
    fileprivate func setupGenreLabels(_ genres: [String]) {
        
    }
}
