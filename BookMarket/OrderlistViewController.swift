//
//  OrderlistViewController.swift
//  BookMarket
//
//  Created by Belle Long on 2022/5/2.
//

import UIKit

class OrderlistViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var database: DatabaseManager!

    @IBOutlet weak var tableView: UITableView!
    
    var orderItems=[OrderItem]()
    var orders=[OrderItem]()
    override func viewDidLoad() {
        super.viewDidLoad()
        database = DatabaseManager()
        database.openDatabase()
        orders=database.getList()
        print(orders.count)
        orderItems=getOrderList()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    func getOrderList()->[OrderItem]{
        for item in orders{
            for i in item.bookItem{
               let i1=database.getItems(name: i.name)[0]
                i.info=i1.info
                i.id=i1.id
                i.pic=i1.pic
                i.author=i1.author
                i.type=i1.type
            }
        }
        return orders
    }
    func getCurrentTime() -> String{
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM-dd"
            let timezone = TimeZone.init(identifier: "Asia/Beijing")
            formatter.timeZone = timezone
            let dateTime = formatter.string(from: Date.init())
            return dateTime
        }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        orders=database.getList()
        
        orderItems=getOrderList()
        tableView.reloadData()
        if(database.getCart().isEmpty == false){
            self.tabBarController?.tabBar.showBadgOn(index: 1, tabbarItemNums: 3,number: database.getCart().count)
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (orderItems.count)
        print(orders.count)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
        {
            return 100;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        let item = orderItems[indexPath.row]
        cell.imageView?.image = item.bookItem[0].pic
        cell.textLabel?.textColor = UIColor.orange
        cell.textLabel?.text = item.bookItem[0].name
        let timeLabel = UILabel(frame: CGRect(x: 250, y: 55, width: 200, height: 30))
        timeLabel.text="实付款："+String(format:"%.2f",item.totalprice)+"元"
        cell.addSubview(timeLabel)
        if(item.count > 1){
            cell.detailTextLabel?.text = "等共" + String(item.count) + "件"
        }
        else{
            cell.detailTextLabel?.text = "共" + String(item.count) + "件"
        }
        return cell
    }
    
    //UITableView的代理方法
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "orderdetailSegue", sender: indexPath.row)
    }
    //通过itemSegue来标识进入下一个页面
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destination: OrderdetailViewController = segue.destination as! OrderdetailViewController
            if sender is Int {
                let item = orderItems[sender as! Int]
               destination.item = item
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


