//
//  feedCellTableViewCell.swift
//  SnapchatClone
//
//  Created by Mustafa Göktuğ İbolar on 10.08.2022.
//

import UIKit

class feedCell: UITableViewCell {
    static let identifier = "CustomCell"
    
    let _imageView : UIImageView = {
        let _imageView = UIImageView()
        return _imageView
        
    }()
    let feedUserNameLabel : UILabel = {
        let feedUserNameLabel = UILabel()
        feedUserNameLabel.textAlignment = .center
        return feedUserNameLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .yellow
        contentView.addSubview(_imageView)
        contentView.addSubview(feedUserNameLabel)
        
        
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = contentView.frame.size.width
        let height = contentView.frame.size.height
        _imageView.frame = CGRect(x: width * 0.15, y: height * 0.1, width: width * 0.7, height: height * 0.6)
        
        feedUserNameLabel.frame = CGRect(x: width * 0.35, y: height * 0.05, width: width * 0.3, height: height * 0.05)
        
    }
    
}
