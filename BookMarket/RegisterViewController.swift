//
//  RegisterViewController.swift
//  BookMarket
//
//  Created by Belle Long on 2022/5/1.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    var database: DatabaseManager!
    @IBOutlet weak var username: UITextField!
    @IBOutlet var leftdown: UIImageView!
    @IBOutlet var rightup: UIImageView!
    @IBOutlet var leftup: UIImageView!
    @IBOutlet var confirmimg: UIImageView!
    @IBOutlet var pwdimg: UIImageView!
    @IBOutlet var userimg: UIImageView!
    @IBOutlet weak var confirm: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var vRegister: UIImageView!
    @IBOutlet weak var owlhead: UIImageView!
    @IBOutlet weak var rightdown: UIImageView!
    //注册框状态
       var showType:LoginShowType = LoginShowType.NONE
    override func viewDidLoad() {
        super.viewDidLoad()
        database=DatabaseManager()
        //登录框背景
        vRegister.layer.borderWidth = 0.5
        vRegister.layer.borderColor = UIColor.lightGray.cgColor
        vRegister.backgroundColor = UIColor.white
//        self.view.addSubview(vLogin)
//
//        //猫头鹰左手(圆形的)
        self.view.addSubview(leftdown)
//
//        //猫头鹰右手(圆形的)
        self.view.addSubview(rightdown)
        self.view.addSubview(rightup)
        self.view.addSubview(leftup)
//        //用户名输入框
        username.delegate = self
        username.layer.cornerRadius = 5
        username.layer.borderColor = UIColor.lightGray.cgColor
        username.layer.borderWidth = 0.5
        username.leftView = userimg
        username.leftViewMode = UITextField.ViewMode.always
        self.view.addSubview(username)

        //密码输入框
        password.delegate = self
        password.layer.cornerRadius = 5
        password.layer.borderColor = UIColor.lightGray.cgColor
        password.layer.borderWidth = 0.5
        password.isSecureTextEntry = true
        password.leftView = pwdimg
        password.leftViewMode = UITextField.ViewMode.always
        self.view.addSubview(password)
        
        //确认密码输入框
        confirm.delegate = self
        confirm.layer.cornerRadius = 5
        confirm.layer.borderColor = UIColor.lightGray.cgColor
        confirm.layer.borderWidth = 0.5
        confirm.isSecureTextEntry = true
        confirm.leftView = confirmimg
        confirm.leftViewMode = UITextField.ViewMode.always
        self.view.addSubview(confirm)
        owlhead.addSubview(rightup)
        owlhead.addSubview(leftup)
    }
    
    //输入框获取焦点开始编辑
    func textFieldDidBeginEditing(_ textField:UITextField)
        {
            //如果当前是用户名输入
            if textField.isEqual(username){
                if (showType != LoginShowType.PASS)
                {
                    showType = LoginShowType.USER
                    return
                }
                showType = LoginShowType.USER
                print(self.leftup.frame.origin.x)
                print(self.rightup.frame.origin.x)
                //播放不遮眼动画
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    self.leftup.frame = CGRect(
                        x: self.leftup.frame.origin.x,
                        y: self.leftup.frame.origin.y + 40,
                        width: 0, height: 0)
                    self.rightup.frame = CGRect(
                        x: self.rightup.frame.origin.x,
                        y: self.rightup.frame.origin.y + 40,
                        width: 0, height: 0)
                    self.leftdown.frame = CGRect(
                        x: self.leftdown.frame.origin.x - 50,
                        y: self.leftdown.frame.origin.y, width: 70, height: 50)
                    self.rightdown.frame = CGRect(
                        x: self.rightdown.frame.origin.x + 50,
                        y: self.rightdown.frame.origin.y, width: 70, height: 50)
                })
            }
            //如果当前是密码名输入
            else if textField.isEqual(password) || textField.isEqual(confirm){
                if (showType == LoginShowType.PASS)
                {
                    showType = LoginShowType.PASS
                    return
                }
                showType = LoginShowType.PASS
                //播放遮眼动画
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    self.leftup.frame = CGRect(
                        x: 40 ,
                        y: 50,
                        width: 70, height: 60)
                    self.rightup.frame = CGRect(
                        x: 90,
                        y: 50,
                        width: 70, height: 60)
                    self.leftdown.frame = CGRect(
                        x: self.leftdown.frame.origin.x+50,
                        y: self.leftdown.frame.origin.y, width: 0, height: 0)
                    self.rightdown.frame = CGRect(
                        x: self.rightdown.frame.origin.x-50,
                        y: self.rightdown.frame.origin.y, width: 0, height: 0)
                })
            }
}
    //提示框
    func showMsgbox(_message: String, _title: String = "提示"){
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertController.Style.alert)
            let btnOK = UIAlertAction(title: "好的", style: .default, handler: nil)
            alert.addAction(btnOK)
            self.present(alert, animated: true, completion: nil)
            
        }
    @IBAction func registerClick(_ sender: UIButton) {
        if(username.text == ""){
            showMsgbox(_message: "请输入用户名");
        }
        else if(password.text == ""){
            showMsgbox(_message: "请输入密码");
        }
        else if(confirm.text == ""){
            showMsgbox(_message: "请再次输入密码");
        }
        else{
            //showMsgbox(_message: "注册成功");
            if(checkPwd()){
                database.insertUser(pwd: password.text!, name: username.text!)
            var loginView = self.storyboard?.instantiateViewController(withIdentifier: "login")
            
            self.present(loginView!, animated: true, completion: nil)
            }
        }
            
    }
    
    func checkPwd() -> Bool{
        if(password.text != confirm.text){
            showMsgbox(_message: "两次输入的密码不一致");
            return false
        }
        else{
            return true
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
