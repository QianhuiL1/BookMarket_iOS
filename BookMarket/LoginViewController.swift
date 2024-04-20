//
//  ViewController.swift
//  BookMarket
//
//  Created by Belle Long on 2022/5/1.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    var database: DatabaseManager!
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
            // Custom initialization
        }
        
    required init(coder aDecoder: NSCoder!) {
        super.init(coder:aDecoder)!
        }
    
    @IBOutlet weak var vLogin: UIImageView!
    @IBOutlet weak var owlhead: UIImageView!
    @IBOutlet weak var userimg: UIImageView!
    @IBOutlet weak var pwdimg: UIImageView!
    @IBOutlet var rightup: UIImageView!
    @IBOutlet var leftup: UIImageView!
    @IBOutlet var leftdown: UIImageView!
    @IBOutlet var rightdown: UIImageView!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    

    //登录框状态
       var showType:LoginShowType = LoginShowType.NONE
    override func viewDidLoad() {
        super.viewDidLoad()
        database=DatabaseManager()
        username.text=UserDefaults.standard.string(forKey: "username")
//        //猫头鹰头部
        owlhead.layer.masksToBounds = true

        //登录框背景
        vLogin.layer.borderWidth = 0.5
        vLogin.layer.borderColor = UIColor.lightGray.cgColor
        vLogin.backgroundColor = UIColor.white
//        self.view.addSubview(vLogin)
//
//        //猫头鹰左手(圆形的)
        self.view.addSubview(leftdown)
//
//        //猫头鹰右手(圆形的)
        self.view.addSubview(rightdown)
        owlhead.addSubview(rightup)
        owlhead.addSubview(leftup)
//        //用户名输入框
        username.delegate = self
        username.layer.cornerRadius = 5
        username.layer.borderColor = UIColor.lightGray.cgColor
        username.layer.borderWidth = 0.5
        username.leftView = userimg
        username.leftViewMode = UITextField.ViewMode.always
        //username.leftView!.addSubview(imgUser)
        self.view.addSubview(username)
//
//        //密码输入框
        password.delegate = self
        password.layer.cornerRadius = 5
        password.layer.borderColor = UIColor.lightGray.cgColor
        password.layer.borderWidth = 0.5
        password.isSecureTextEntry = true
        password.leftView = pwdimg
        password.leftViewMode = UITextField.ViewMode.always
//
//        //密码输入框左侧图标
//        password.leftView!.addSubview(pwdimg)
        self.view.addSubview(password)
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
                        y: self.leftup.frame.origin.y+50,
                        width: 70, height: 60)
                    self.rightup.frame = CGRect(
                        x: self.rightup.frame.origin.x,
                        y: self.rightup.frame.origin.y + 50,
                        width: 70, height: 60)
                    self.leftdown.frame = CGRect(
                        x: self.leftdown.frame.origin.x - 50,
                        y: self.leftdown.frame.origin.y, width: 70, height: 50)
                    self.rightdown.frame = CGRect(
                        x: self.rightdown.frame.origin.x + 50,
                        y: self.rightdown.frame.origin.y, width: 70, height: 50)
                })
            }
            //如果当前是密码名输入
            else if textField.isEqual(password){
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
    private func saveLoginData(){
        
        UserDefaults.standard.set(username.text!, forKey: "username")
        UserDefaults.standard.set(password.text!, forKey: "password")
    }
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
    
    //提示框
    func showMsgbox(_message: String, _title: String = "提示"){
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertController.Style.alert)
            let btnOK = UIAlertAction(title: "好的", style: .default, handler: nil)
            alert.addAction(btnOK)
            self.present(alert, animated: true, completion: nil)
            
        }
        
    @IBAction func loginClick(_ sender: UIButton) {
        if(username.text == ""){
            showMsgbox(_message: "请输入用户名");
        }
        else if(password.text == ""){
            showMsgbox(_message: "请输入密码");
        }
        else{
            let np=database.getUser()
            if np[username.text!] != password.text!{
                showMsgbox(_message: "密码或用户名输入不正确！");
            }
            else{
                saveLoginData()
                let sb=UIStoryboard(name: "Main", bundle: nil)
                let vc=sb.instantiateViewController(withIdentifier: "booklist") as! UITabBarController
                vc.isModalInPresentation=true
                vc.modalPresentationStyle=UIModalPresentationStyle.overFullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func registerClick(_ sender: UIButton) {
        var registerView = self.storyboard?.instantiateViewController(withIdentifier: "register")
        self.present(registerView!, animated: true, completion: nil)
        
    }
}
//登录框状态枚举
enum LoginShowType {
    case NONE
    case USER
    case PASS
}
