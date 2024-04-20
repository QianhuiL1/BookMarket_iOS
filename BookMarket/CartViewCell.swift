//
//  CartViewCell.swift
//  BookMarket
//
//  Created by Belle Long on 2022/5/10.
//

import UIKit

class CartViewCell: UITableViewCell {

    let width:CGFloat = UIScreen.main.bounds.width
    var decreaseBtn: UIButton!     // 减按钮
    var increaseBtn: UIButton!     // 加按钮
    var numberLabel:UILabel!
    var nameLabel:UILabel!      // 书名
    var priceLabel:UILabel!  // 价格
    var bookImg:UIImageView!    // 图片
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        bookImg = UIImageView(frame: CGRect(x: 20, y: 15, width: 95, height: 95))
        bookImg.layer.masksToBounds = true
        bookImg.layer.cornerRadius = 4.0
        
        nameLabel = UILabel(frame: CGRect(x: 130, y: 25, width: 200, height: 24))
        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nameLabel.textAlignment = .left
  
        priceLabel = UILabel(frame: CGRect(x: width-94, y: 70, width: 100, height: 22))
        priceLabel.textColor = UIColor.orange
        priceLabel.font = UIFont.systemFont(ofSize: 22)
        priceLabel.textAlignment = .left
        numberLabel = UILabel(frame: CGRect(x: 180, y: 75, width: 30, height: 30))
        decreaseBtn = UIButton(frame: CGRect(x: 140, y: 75, width: 30, height: 30))
        decreaseBtn.setTitle("-", for: UIControl.State())
        decreaseBtn.setTitleColor(UIColor.gray, for: UIControl.State())
        increaseBtn = UIButton(frame: CGRect(x: 200, y: 75, width: 30, height: 30))
        increaseBtn.setTitle("+", for: UIControl.State())
        increaseBtn.setTitleColor(UIColor.gray, for: UIControl.State())
        contentView.addSubview(numberLabel)
        contentView.addSubview(increaseBtn)
        contentView.addSubview(decreaseBtn)
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
