//
//  SuccessViewController.swift
//  BookMarket
//
//  Created by Belle Long on 2022/5/21.
//
import UIKit
class SuccessViewController: UIViewController  {
@IBOutlet weak var returnBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func ReturnClick(_ sender: Any) {
        let sb=UIStoryboard(name: "Main", bundle: nil)
        let vc=sb.instantiateViewController(withIdentifier: "booklist") as! UITabBarController
        vc.isModalInPresentation=true
        vc.modalPresentationStyle=UIModalPresentationStyle.overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
