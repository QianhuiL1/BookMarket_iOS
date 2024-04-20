//
//  OrderdetailViewController.swift
//  BookMarket
//
//  Created by Belle Long on 2022/5/2.
//
import UIKit
class OrderdetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var item: OrderItem?
        override func viewDidLoad() {
            super.viewDidLoad()
            view.addSubview(tableView)
            tableView.dataSource = self
            tableView.delegate = self
            idLabel.text="订单编号："+item!.id
            priceLabel.text = "总价："+String(format: "%.2f", item?.totalprice as! CVarArg)+" 元"
            timeLabel.text="下单时间："+item!.time
        }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
        {
            return 110;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (item?.bookItem.count)!
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return "商品信息"
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell")
        let item = item?.bookItem[indexPath.row]
        cell.imageView?.image = item?.pic
        cell.textLabel?.textColor = UIColor.orange
        cell.textLabel?.text = item?.name
        
        cell.detailTextLabel?.text = String(item!.price)

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "bookdetailSegue", sender: indexPath.row)
    }
    //通过itemSegue来标识进入下一个页面
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destination: BookdetailViewController = segue.destination as! BookdetailViewController
        destination.item = item?.bookItem[sender as! Int]
            
        }
    
       
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
}

