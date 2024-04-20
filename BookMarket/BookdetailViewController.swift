//
//  BookdetailViewController.swift
//  BookMarket
//
//  Created by Belle Long on 2022/5/2.
//
import UIKit
import Foundation

class BookdetailViewController: UIViewController,UITextViewDelegate {
    var database: DatabaseManager!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var infoLabel: UITextView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var booknameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bookView: UIImageView!
    var item: BookItem?
    var addItemDelegate: AddItemDelegate?
        override func viewDidLoad() {
            super.viewDidLoad()
            infoLabel.delegate = self
            self.view.addSubview(infoLabel)
            database = DatabaseManager()
addItemDelegate = CartViewController()
            let item=UIBarButtonItem(title: "返回", style: .plain, target: self, action: nil)
            self.navigationItem.leftBarButtonItem=item
        }
    let width:CGFloat = UIScreen.main.bounds.width
    override func viewWillAppear(_ animated: Bool) {
        item?.num=0
            if item != nil {
                idLabel.text = "书号：" + item!.id
                bookView.image = item?.pic
                authorLabel.text = "作者：" + item!.author
                infoLabel.text = "      " + item!.info
                booknameLabel.text = "书名：" + item!.name
                priceLabel.text = "单价：" +  String(item!.price)
            }
        }
       
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }

    @IBAction func addClick(_ sender: Any) {
        addItemDelegate?.addItem(item: item!)
        item?.num=1
        database.insertCartItem1(item: item!)
    }
    
}
