//
//  DatabaseManager.swift
//  BookMarket
//
//  Created by Belle Long on 2022/5/16.
//

import Foundation
import SQLite3
import UIKit
class DatabaseManager{
    init(){
        openDatabase()
        createTable()
    }
func dataFileURL() ->String{
    let urls=FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    var url:String?
    url = ""
    do{
        try url = (urls.first?.appendingPathComponent("data.db").path)
    }catch{
        print("Error is \(error)")
    }
    return url!
}
var database: OpaquePointer?=nil
func openDatabase(){
    var result = sqlite3_open_v2(dataFileURL(), &database,SQLITE_OPEN_READWRITE|SQLITE_OPEN_FULLMUTEX|SQLITE_OPEN_CREATE, nil)
    if result != SQLITE_OK{
        sqlite3_close(database)
        print("Failed to open database!")
        return
    }
}
    func createTable(){
        let createSQL1 = "CREATE TABLE IF NOT EXISTS cart" + "(id INTEGER PRIMARY KEY AUTOINCREMENT,name VARCHAR(40) NOT NULL,price DOUBLE NOT NULL,number INTEGER NOT NULL);"
        let createSQL2 = "CREATE TABLE IF NOT EXISTS orderlist" + "(id CHAR(5) NOT NULL,number INTEGER NOT NULL,name VARCHAR(40) NOT NULL,price DOUBLE NOT NULL,time char(20) NOT NULL);"
        let createSQL = "CREATE TABLE IF NOT EXISTS user" + "(id INTEGER PRIMARY KEY AUTOINCREMENT,name VARCHAR(40) NOT NULL,password VARCHAR(40) NOT NULL);"
        var errMsg:UnsafeMutablePointer<Int8>? = nil
        if(sqlite3_exec(database, createSQL, nil, nil, &errMsg) != SQLITE_OK){
            sqlite3_close(database)
            print("Failed to create TABLE user")
            return
        }
        if(sqlite3_exec(database, createSQL1, nil, nil, &errMsg) != SQLITE_OK){
            sqlite3_close(database)
            print("Failed to create TABLE cart")
            return
        }
        if(sqlite3_exec(database, createSQL2, nil, nil, &errMsg) != SQLITE_OK){
            sqlite3_close(database)
            print("Failed to create TABLE order")
            return
        }
    }
    func getCart()->[BookItem]{
        openDatabase()
        var items=[BookItem]()
        var query = "SELECT name,price,sum(number) FROM cart group by name;"
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW{
                let item:BookItem=BookItem()
                let name = sqlite3_column_text(statement, 0)
                let price = sqlite3_column_double(statement, 1)
                let number = sqlite3_column_int(statement, 2)
                item.name=String.init(cString: name!)
                item.price=price
                item.num = Int(number)
                items.append(item)
            }
                sqlite3_finalize(statement)
        }
                sqlite3_close(database)
            
        return items
    }
    func getItems(name:String)->[BookItem]{
        openDatabase()
    var items=[BookItem]()
    var query = "SELECT name,image,type,price,id,info,author,number FROM book;"
        if name != "" {
            query = "SELECT name,image,type,price,id,info,author,number FROM book"+" where name='"+name+"';"
        }
    var statement:OpaquePointer? = nil
    if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK{
        while sqlite3_step(statement) == SQLITE_ROW{
            let item:BookItem=BookItem()
            let name = sqlite3_column_text(statement, 0)
            let len = sqlite3_column_bytes(statement, 1)
            let image = Data(bytes: sqlite3_column_blob(statement,1), count: Int(len))
            let type = sqlite3_column_text(statement, 2)
            let price = sqlite3_column_double(statement, 3)
            let id = sqlite3_column_double(statement, 4)
            let info = sqlite3_column_text(statement, 5)
            let author = sqlite3_column_text(statement, 6)
            let number = sqlite3_column_text(statement, 7)
            item.name=String.init(cString: name!)
            item.type=String.init(cString: type!)
            item.price=price
            item.pic=UIImage(data: image)!
            //item.pic=UIImage(named: "iconfont-user.png")!
            item.info=String.init(cString: info!)
            item.author=String.init(cString: author!)
            item.id = String.init(cString: number!)
            items.append(item)
        }
        if name == ""{
            sqlite3_finalize(statement)
        }
        
    }
        if name == ""{
            sqlite3_close(database)
        }
        
    return items
}
    func getList()->[OrderItem]{
        openDatabase()
        var items=[BookItem]()
        var orderItems=[OrderItem]()
        let query = "SELECT id,name,price,number,time FROM orderlist;"
        var ID:String=""
        var name1=""
        var id1=""
        var time1=""
        var total=0.0
        var number=0
        var time11=""
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW{
                let id = sqlite3_column_text(statement, 0)
                let name = sqlite3_column_text(statement, 1)
                let price = sqlite3_column_double(statement, 2)
                let time = sqlite3_column_text(statement, 4)
                number = Int(sqlite3_column_int(statement, 3))
                name1=String.init(cString: name!)
                id1=String.init(cString: id!)
                
                if(ID == ""){
                    ID=id1
                }
                
                if(id1 != ID){
                    time11=time1
                    total=0.0
                    for item in items {
                        total+=item.price*Double(number)
                    }
                    orderItems.append(OrderItem(book: items, totalprice: total, id: ID,time: time1, count: items.count))
                    items.removeAll()
                    ID=id1
                }
                items.append(BookItem(name: name1, price: price, num: Int(number)))
                time1=String.init(cString: time!)
            }
            sqlite3_finalize(statement)
            total=0.0
            for item in items {
                total+=item.price*Double(number)
            }
            orderItems.append(OrderItem(book: items, totalprice: total, id: ID,time: time11, count: items.count))
        }
        sqlite3_close(database)
        orderItems[orderItems.count-1].time=time1
        return orderItems
    }
    func getUser()->[String:String]{
        openDatabase()
        let query = "SELECT name,password FROM user;"
        var statement:OpaquePointer? = nil
        var np=[String:String]()
        var name=""
        var pwd=""
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW{
                let name1 = sqlite3_column_text(statement, 0)
                let password1 = sqlite3_column_text(statement, 1)
                pwd=String.init(cString: password1!)
                name=String.init(cString: name1!)
                np.updateValue(pwd, forKey: name)
            }
                sqlite3_finalize(statement)
        }
                sqlite3_close(database)
            return np
    }
    func insertCartItem1(item: BookItem){
        openDatabase()
        var errMsg:UnsafeMutablePointer<Int8>? = nil
        let update = "INSERT OR REPLACE INTO cart (name,price,number)"+"VALUES (?,?,?);"
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, update, -1, &statement, nil) == SQLITE_OK{
            sqlite3_bind_text(statement, 1, item.name, -1, nil)
            sqlite3_bind_double(statement, 2, item.price)
            sqlite3_bind_int(statement, 3, Int32(item.num))
            if sqlite3_step(statement) != SQLITE_DONE{
                print("ERROR UPDATE TABLE")
                sqlite3_close(database)
                return
            }
            sqlite3_finalize(statement)
    }
    sqlite3_close(database)
    }
func insertCartItem(book: [BookItem]){
    openDatabase()
    let deleteSQL = "DELETE FROM cart"
    var errMsg:UnsafeMutablePointer<Int8>? = nil
    if(sqlite3_exec(database, deleteSQL, nil, nil, &errMsg) != SQLITE_OK){
        sqlite3_close(database)
        print("Failed to delete TABLE cart")
        return
    }
    for item in book{
        let update = "INSERT OR REPLACE INTO cart (name,price,number)"+"VALUES (?,?,?);"
        var statement:OpaquePointer? = nil
        if sqlite3_prepare_v2(database, update, -1, &statement, nil) == SQLITE_OK{
            sqlite3_bind_text(statement, 1, item.name, -1, nil)
            sqlite3_bind_double(statement, 2, item.price)
            sqlite3_bind_int(statement, 3, Int32(item.num))
            if sqlite3_step(statement) != SQLITE_DONE{
                print("ERROR UPDATE TABLE")
                sqlite3_close(database)
                return
            }
            sqlite3_finalize(statement)
        }
    }
    
    sqlite3_close(database)
    
}
    func insertOrderItem(book: [BookItem],id: String,time: String){
        openDatabase()
        for item in book{
            let update = "INSERT OR REPLACE INTO orderlist (id,name,price,number,time)"+"VALUES (?,?,?,?,?);"
            var statement:OpaquePointer? = nil
            let id1=id as! NSString
            let name1=item.name as! NSString
            if sqlite3_prepare_v2(database, update, -1, &statement, nil) == SQLITE_OK{
                sqlite3_bind_text(statement, 1, id1.utf8String, -1, nil)
                sqlite3_bind_text(statement, 2, name1.utf8String, -1, nil)
                sqlite3_bind_double(statement, 3, item.price)
                sqlite3_bind_int(statement, 4, Int32(item.num))
                sqlite3_bind_text(statement, 5, time, -1, nil)
                
                if sqlite3_step(statement) != SQLITE_DONE{
                    print("ERROR UPDATE TABLE")
                    sqlite3_close(database)
                    return
                }
                sqlite3_finalize(statement)
            }
        }
        sqlite3_close(database)
    }
    func insertUser(pwd:String,name:String){
        openDatabase()
            let update = "INSERT OR REPLACE INTO user (name,password)"+"VALUES (?,?);"
            var statement:OpaquePointer? = nil
            let name1=name as! NSString
        let pwd1=pwd as! NSString
            if sqlite3_prepare_v2(database, update, -1, &statement, nil) == SQLITE_OK{
                sqlite3_bind_text(statement, 1, name1.utf8String, -1, nil)
                sqlite3_bind_text(statement, 2, pwd1.utf8String, -1, nil)
                
                if sqlite3_step(statement) != SQLITE_DONE{
                    print("ERROR UPDATE TABLE")
                    sqlite3_close(database)
                    return
                }
                sqlite3_finalize(statement)
            }
        sqlite3_close(database)
    }

}
