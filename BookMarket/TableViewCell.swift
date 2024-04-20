//
//  TableViewCell.swift
//  BookMarket
//
//  Created by Belle Long on 2022/5/6.
//

import UIKit

class TableViewCell: UITableViewCell {

    let width:CGFloat = UIScreen.main.bounds.width
    var nameLabel:UILabel!      // 书名
    var priceLabel:UILabel!  // 价格
    var bookImg:UIImageView!    // 图片
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        bookImg = UIImageView(frame: CGRect(x: 20, y: 15, width: 95, height: 95))
        bookImg.layer.masksToBounds = true
        bookImg.layer.cornerRadius = 4.0
        
        nameLabel = UILabel(frame: CGRect(x: width-240, y: 25, width: 200, height: 24))
        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nameLabel.textAlignment = .right
  
        priceLabel = UILabel(frame: CGRect(x: width-140, y: 70, width: 100, height: 22))
        priceLabel.textColor = UIColor.orange
        priceLabel.font = UIFont.systemFont(ofSize: 22)
        priceLabel.textAlignment = .right
        
        contentView.addSubview(bookImg)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
