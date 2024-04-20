//
//  BooklistViewController.swift
//  BookMarket
//
//  Created by Belle Long on 2022/5/2.
//

import UIKit
import SQLite3
class BooklistViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var database: DatabaseManager!
    @IBOutlet weak var tableView: UITableView!
    var bookItems:[BookItem]?
    var book:[BookItem]?
    var wenn=[BookItem]()
    var jii=[BookItem]()
    var ficc=[BookItem]()
    var zhii=[BookItem]()
    var tongg=[BookItem]()
    func getCartItems()->[BookItem]{
        let items=database.getCart()
        for item in items{
            let i=database.getItems(name: item.name)[0]
            item.pic=i.pic
        }
        return items
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        database = DatabaseManager()
        database.openDatabase()
        bookItems=database.getItems(name: "")
        book=bookItems
        CartViewController.toBuyItems=getCartItems()
        if(database.getCart().isEmpty == false){
            self.tabBarController?.tabBar.showBadgOn(index: 1, tabbarItemNums: 3,number: database.getCart().count)}
        else{
            self.tabBarController?.tabBar.hideBadg(on: 1)
        }
        var timer=Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(recordTime), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
        
        //database.read()
    }
    @objc func recordTime(){
        if(database.getCart().isEmpty == false){
            self.tabBarController?.tabBar.showBadgOn(index: 1, tabbarItemNums: 3,number: database.getCart().count)}
        else{
            self.tabBarController?.tabBar.hideBadg(on: 1)
        }
    }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfSectionsInTableView section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var wen:Int=0
        var ji:Int=0
        var fic:Int=0
        var zhi:Int=0
        var tong:Int=0
        for item in bookItems!{
            if item.type == "文学"{
                wenn.append(item)
                wen+=1
                
            }else if item.type == "传记"{
                jii.append(item)
                ji+=1
            }else if item.type == "小说"{
                ficc.append(item)
                fic+=1
            }else if item.type == "政治"{
                zhii.append(item)
                zhi+=1
            }else if item.type == "童书"{
                tongg.append(item)
                tong+=1
            }
                
        }
    switch(section) {

    case 0: return wen

    case 1: return ji

    case 2: return fic
        
    case 3: return zhi
        
    case 4: return tong

    default: return 0

    } }

    //往每个section里面填入相应的cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var CellIdentifier:NSString=NSString .localizedStringWithFormat("Cell%d%d", indexPath.section,indexPath.row)
        var cell:TableViewCell? = tableView.dequeueReusableCell(withIdentifier: CellIdentifier as String) as? TableViewCell
        if cell==nil{
            cell = TableViewCell(style: .subtitle, reuseIdentifier: CellIdentifier as String)
        }
        func cellpro(type:String) -> UITableViewCell{
            for item in bookItems!{
                if item.type == type{
                    cell?.bookImg.image = item.pic
                    cell?.nameLabel.text = item.name
                            cell?.priceLabel?.text = "$" + String(item.price)
                    bookItems=bookItems?.filter{$0.name != item.name}
                    return cell!
                }
            }
            return cell!
        }
        switch(indexPath.section){
        case 0:return cellpro(type: "文学")
        case 1:return cellpro(type: "传记")
        case 2:return cellpro(type: "小说")
        case 3:return cellpro(type: "政治")
        case 4:return cellpro(type: "童书")
        default:return cell!
        }
                
        }

    //最后对每个section取个title，再调整它的header和footer的高度就好了
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

            var sectionName: String = ""

    switch(section){
    case 0: sectionName = "文学"; break;
    case 1: sectionName = "传记"; break;
    case 2: sectionName = "小说"; break;
    case 3: sectionName = "政治"; break;
    case 4: sectionName = "童书"; break;
    default: sectionName = ""
    }
    return sectionName;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> Float {
return 10;
    }


    //section里面每个row的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
        {
            return 120;
    }

    override func viewWillAppear(_ animated: Bool) {
        bookItems=book
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
    }

    var section:String?
    //UITableView的代理方法
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0){
            section="wen"
        }else if(indexPath.section == 1){
            section="ji"
        }else if(indexPath.section == 2){
            section="fic"
        }else if(indexPath.section == 3){
            section="zhi"
        }
        else if(indexPath.section == 4){
            section="tong"
        }
        performSegue(withIdentifier: "bookdetailSegue", sender: indexPath.row)
    }
    //通过itemSegue来标识进入下一个页面
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destination: BookdetailViewController = segue.destination as! BookdetailViewController
        var item = wenn[sender as! Int]
            if sender is Int {
                if(section == "wen"){
                    item = wenn[sender as! Int]
                }else if(section == "ji"){
                    item = jii[sender as! Int]
                }else if(section == "fic"){
                    item = ficc[sender as! Int]
                }else if(section == "zhi"){
                    item = zhii[sender as! Int]
                }else if(section == "tong"){
                    item = tongg[sender as! Int]
                }
                
               destination.item = item
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

