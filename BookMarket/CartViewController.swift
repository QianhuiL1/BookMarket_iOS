//
//  CartViewController.swift
//  BookMarket
//
//  Created by Belle Long on 2022/5/2.
//

import UIKit
import Foundation
protocol AddItemDelegate{
    func addItem(item: BookItem)
}
class CartViewController: UIViewController,UITableViewDelegate,AddItemDelegate,UITableViewDataSource   {
    @IBOutlet weak var tableView: UITableView!
    var database: DatabaseManager!
    var total=0.0
    var cnt=0
    var count:UILabel!
    var money:UILabel!
    var cellArry=[IndexPath]()
    func addItem(item: BookItem) {
        item.num += 1
        for i in CartViewController.toBuyItems{
            if item.name == i.name{
                i.num += 1
                return
            }
        }
        CartViewController.toBuyItems.append(item)
    }
    var i=0
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        if(database.getCart().isEmpty == false){
            self.tabBarController?.tabBar.showBadgOn(index: 1, tabbarItemNums: 3,number: database.getCart().count)}
        else{
            self.tabBarController?.tabBar.hideBadg(on: 1)
        }
        if(i != 0){
        database.insertCartItem(book: CartViewController.toBuyItems)
        }
    }
    static var toBuyItems = [BookItem]()
    func getCartItems()->[BookItem]{
        let items=database.getCart()
        for item in items{
            let i=database.getItems(name: item.name)[0]
            item.pic=i.pic
            
        }
        return items
    }
    override func viewDidLoad() {
        i+=1
        super.viewDidLoad()
        database=DatabaseManager()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        let bookview = BookdetailViewController()
        bookview.addItemDelegate = self
        CartViewController.toBuyItems=getCartItems()
        let statusbarheight=UIApplication.shared.statusBarFrame.height
        let insets=UIEdgeInsets(top:statusbarheight,left:0,bottom:0,right:0)
        tableView.contentInset=insets
        tableView.scrollIndicatorInsets=insets
        let theRefreshcontrol=UIRefreshControl()
        theRefreshcontrol.attributedTitle=NSAttributedString(string:"刷新")
        theRefreshcontrol.addTarget(self, action: #selector(refreshing), for: .valueChanged)
        tableView.refreshControl=theRefreshcontrol
        let screen=UIScreen.main.bounds
        let tableRect=CGRect(x:0,y:250,width:screen.width,height:500)
        var tlb1=UILabel(frame:CGRect(x:5,y:tableRect.maxY+5,width:60,height:60))
        tlb1.text="合计"
        tlb1.textColor=UIColor.gray
        var tlb2=UILabel(frame:CGRect(x:65,y:tableRect.maxY+5,width:60,height:60))
        tlb2.text="数量："
        tlb2.textColor=UIColor.black  ;
        count = UILabel(frame:CGRect(x:115,y:tableRect.maxY+5,width:60,height:60))
        count.text="0"
        count.textColor=UIColor.red;
        var tlb3=UILabel(frame:CGRect(x:150,y:tableRect.maxY+5,width:60,height:60))
        tlb3.text="总额："
        tlb3.textColor=UIColor.black;
        money=UILabel(frame:CGRect(x:195,y:tableRect.maxY+5,width:80,height:60))
        money.text="0.0"
        money.textColor=UIColor.red
        let tbt1=UIButton(frame:CGRect(x:screen.width-160,y:tableRect.maxY+5,width:80,height:60))
        tbt1.setTitle("删除", for: .normal)
        tbt1.backgroundColor=UIColor.blue
        let tbt=UIButton(frame:CGRect(x:screen.width-80,y:tableRect.maxY+5,width:80,height:60))
        tbt.setTitle("结算", for: .normal)
        tbt.backgroundColor=UIColor.orange
        tbt1.addTarget(self, action: #selector(CartViewController.delItem),
                     for: .touchUpInside)
        tbt.addTarget(self, action: #selector(CartViewController.payItem),
                     for: .touchUpInside)
        self.view.addSubview(tlb1)
        self.view.addSubview(count)
        self.view.addSubview(money)
        self.view.addSubview(tbt)
        self.view.addSubview(tbt1)
        self.view.addSubview(tlb2)
        self.view.addSubview(tlb3)
    }
    //表格项数量
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (CartViewController.toBuyItems.count)
}
    //表格内容
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell:CartViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell") as? CartViewCell
    if cell==nil{
        cell = CartViewCell(style: .subtitle, reuseIdentifier: "cell")
    }
    let item = CartViewController.toBuyItems[indexPath.row]
    cell?.bookImg.image = item.pic
    cell?.nameLabel.textColor = UIColor.orange
    cell?.nameLabel.text = item.name
    //cell.detailTextLabel?.text = String(item.num)
    cell?.numberLabel.text=String(item.num)
    cell?.decreaseBtn.addTarget(self, action: #selector(CartViewController.decrease),
                 for: .touchUpInside)
    cell?.increaseBtn.addTarget(self, action: #selector(CartViewController.increase),
                 for: .touchUpInside)
    cell?.accessoryType=UITableViewCell.AccessoryType.none
    return cell!
}
    @objc func decrease(_ sender: UIButton){
        let cell=superCell(of: sender)
        let index:IndexPath=tableView.indexPath(for: cell!)!
        let book = CartViewController.toBuyItems[index.row]
        CartViewController.toBuyItems[index.row].num-=1
        if(CartViewController.toBuyItems[index.row].num<=0){
            if(cell!.accessoryType == UITableViewCell.AccessoryType.checkmark){
                self.total-=book.price
                cnt-=1
                money.text="\(self.total)"
                count.text="\(cnt)"
                cellArry.remove(at:index.row)
            }
            CartViewController.toBuyItems.remove(at: index.row)
        }
        tableView.reloadData()
    }
    @objc func increase(_ sender: UIButton){
        let cell=superCell(of: sender)
        let index:IndexPath=tableView.indexPath(for: cell!)!
        CartViewController.toBuyItems[index.row].num+=1
        tableView.reloadData()
    }
    
    func superCell(of: UIButton)->UITableViewCell?{
        for view in sequence(first: of.superview, next: {$0?.superview}){
            if let cell = view as? UITableViewCell{
                return cell
            }
        }
        return nil
    }
    //选中商品
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell=tableView.cellForRow(at: indexPath)
        let book=CartViewController.toBuyItems[indexPath.row];
        if(cell?.accessoryType==UITableViewCell.AccessoryType.none){
            //出现✅
            cell?.accessoryType=UITableViewCell.AccessoryType.checkmark
            //加数量和金额
            self.total+=book.price*Double(book.num)
            cnt+=book.num
            let totl=String(format:"%.2f",self.total)
            money.text=totl
            count.text="\(cnt)"
            self.cellArry.append(indexPath)
        }
        else{
            cell?.accessoryType=UITableViewCell.AccessoryType.none
            //减数量和金额
            self.total-=book.price*Double(book.num)
            cnt-=book.num
            money.text="\(self.total)"
            count.text="\(cnt)"
            let row=cellArry.index(of: indexPath)
            cellArry.remove(at:row!)
            
        }
        
    }
    @objc func delItem(_ sender: UIButton){
        self.money.text="0.0"
        self.count.text="0.0"
        cnt=0
        self.total=0
        let cartItems=CartViewController.toBuyItems
        for value in self.cellArry{
            var i=0
            for item in CartViewController.toBuyItems{
                if(item.name == cartItems[value.row].name){
                    CartViewController.toBuyItems.remove(at: i)
                }else{
                    i+=1
                }
            }
        }
        cellArry.removeAll()
        tableView.reloadData()
        database.insertCartItem(book: CartViewController.toBuyItems)
        if(database.getCart().isEmpty == false){
            self.tabBarController?.tabBar.showBadgOn(index: 1, tabbarItemNums: 3,number: database.getCart().count)}
        else{
            self.tabBarController?.tabBar.hideBadg(on: 1)
        }
    }
    @objc func payItem(_ sender: UIButton){
        let alert = UIAlertController(title: "提示", message: "是否确认支付？", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "确认", style: .default, handler: {_ in
            var payItems=[BookItem]()
            self.money.text="0.0"
            self.count.text="0.0"
            self.cnt=0
            self.total=0
            
            for value in self.cellArry{
                payItems.append(CartViewController.toBuyItems[value.row])
            }
            let id=self.randomString(len: 8)
            self.database.insertOrderItem(book: payItems, id: id,time: self.getCurrentTime())
            let cartItems=CartViewController.toBuyItems
            for value in self.cellArry{
                var i=0
                for item in CartViewController.toBuyItems{
                    if(item.name == cartItems[value.row].name){
                        CartViewController.toBuyItems.remove(at: i)
                    }else{
                        i+=1
                    }
                }
                
            }
            self.cellArry.removeAll()
            self.tableView.reloadData()
            self.database.insertCartItem(book: CartViewController.toBuyItems)
            if(self.database.getCart().isEmpty == false){
                self.tabBarController?.tabBar.showBadgOn(index: 1, tabbarItemNums: 3,number: self.database.getCart().count)}
            else{
                self.tabBarController?.tabBar.hideBadg(on: 1)
            }
            let sb=UIStoryboard(name: "Main", bundle: nil)
            let vc=sb.instantiateViewController(withIdentifier: "success") as! UIViewController
            vc.isModalInPresentation=true
            vc.modalPresentationStyle=UIModalPresentationStyle.overFullScreen
            self.present(vc, animated: true, completion: nil)
        })
        let cancel = UIAlertAction(title: "取消", style: .default, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
    }
    //刷新
    @objc func refreshing(){
       if(tableView.refreshControl?.isRefreshing == true){
           tableView.refreshControl?.attributedTitle
               = NSAttributedString(string:"loading")
           tableView.reloadData()
           tableView.refreshControl?.endRefreshing()
           let titleLabel = UILabel(frame:CGRect(x:150,y:90,width:100,height:40))
           titleLabel.text = "刷新成功"
           titleLabel.backgroundColor = UIColor.white
           titleLabel.font = UIFont.systemFont(ofSize: 17)
           
           titleLabel.textAlignment = NSTextAlignment.center
           titleLabel.textColor = UIColor.gray
           
           titleLabel.layer.cornerRadius = 5
           
           titleLabel.layer.masksToBounds = true
           
           titleLabel.numberOfLines = 0
           
            UIView.animate(withDuration: 0.5, animations: {
                self.view.addSubview(titleLabel)
             },completion: {(b:Bool) -> Void in
                   
           DispatchQueue.main.asyncAfter(deadline: .now() + 5) {//弹出以后一秒后自行消失
                titleLabel.removeFromSuperview()
           }
              })
       }
   }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
        {
            return 120;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getCurrentTime()->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let timeZone = TimeZone.init(identifier: "Asia/Beijing")
        let dateTime = formatter.string(from: Date.init())
        return dateTime
    }
    func randomString(len:Int)->String{
        let letters = "SFEHY0123456789"
        return String((0..<len).map{_ in letters.randomElement()!})
    }
}
