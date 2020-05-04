//
//  CommentCell.swift
//  Thousand-Test
//
//  Created by Aibol Tungatarov on 5/3/20.
//  Copyright © 2020 Aibol Tungatarov. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.medium(size: 18)
        label.textColor = .white
        return label
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.light(size: 16)
        label.textColor = UIColor.commentColor
        label.numberOfLines = 0
        return label
    }()
    
    var comment: Comment? {
        didSet {
            usernameLabel.text = comment?.author
            guard let content = comment?.content else {
                return
            }
            commentLabel.setAttributedHtmlText(content)
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    private func configUI() {
        backgroundColor = .clear
        [usernameLabel, commentLabel].forEach {
            addSubview($0)
        }
        makeConstraints()
    }
    
    private func makeConstraints() {
        usernameLabel.snp.makeConstraints { (m) in
            m.top.equalToSuperview().offset(10)
            m.left.equalToSuperview().offset(20)
        }
        
        commentLabel.snp.makeConstraints { (m) in
            m.left.equalTo(usernameLabel)
            m.top.equalTo(usernameLabel.snp.bottom).offset(10)
            m.trailing.lessThanOrEqualToSuperview().offset(-20)
            m.bottom.equalToSuperview().offset(-15).priority(.high)
        }
    }
}
