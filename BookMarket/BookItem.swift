//
//  BookItem.swift
//  BookMarket
//
//  Created by Belle Long on 2022/5/2.
//

import Foundation
import UIKit
import SQLite
class BookItem {
    var name: String = ""
    var price: Double = 0
    var author: String = ""
    var type: String = ""
    var info: String = ""
    var pic: UIImage = UIImage()
    var num: Int = 1
    var id: String = ""
    //指定构造器
    init (name: String, price: Double, author: String, info: String, pic: UIImage) {
        self.name = name
        self.price = price
        self.author = author
        self.info = info
        self.pic = pic
        self.num = 0
    }
    //便利构造器
    init (name: String, price: Double, num: Int) {
        self.name = name
        self.price = price
        self.author = ""
        self.info = ""
        self.pic = UIImage(named: "iconfont-user.png")!
        self.num = num
        self.id = ""
        self.type=""
    }
    init () {
        self.name = ""
        self.price = 0
        self.author = ""
        self.info = ""
        self.type=""
        self.pic = UIImage()
        self.num = 0
        self.id = ""
    }
    //Item的描述方法,用于在调试时返回类信息
    func description() -> String {
        return ("name: \(name)  price: \(price)  author: \(author) info: \(info)")
    }


}
