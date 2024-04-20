//
//  OrderItem.swift
//  BookMarket
//
//  Created by Belle Long on 2022/5/2.
//

import Foundation
import UIKit

class OrderItem {
    var bookItem: [BookItem]
    var id: String
    var time: String
    var totalprice: Double = 0
    var count: Int = 0

    //指定构造器
    init (book: [BookItem], totalprice: Double, id: String, time: String, count: Int) {
        self.bookItem = book
        self.totalprice = totalprice
        self.id = id
        self.time = time
        self.count = count
    }
    //简易构造器
    init () {
        self.bookItem = [BookItem(name: "昆虫记", price: 20, author: "法布尔", info:"123",pic: UIImage(named: "iconfont-user.png")!)]
        self.totalprice = 0
        self.id = "000"
        self.time = "2022-01-01"
        self.count = 0
    }


}
