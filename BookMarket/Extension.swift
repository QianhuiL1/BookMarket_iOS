//
//  Extension.swift
//  BookMarket
//
//  Created by Belle Long on 2022/5/21.
//
import UIKit
fileprivate let lxfFlag: Int = 666
 
extension UITabBar {
    // MARK:- 显示小红点
    func showBadgOn(index itemIndex: Int, tabbarItemNums: CGFloat = 3.0, number: Int) {
        // 移除之前的小红点
        self.removeBadgeOn(index: itemIndex)
        
        // 创建小红点
        let bageView = UIView()
        bageView.tag = itemIndex + lxfFlag
        bageView.layer.cornerRadius = 8.5
        bageView.backgroundColor = UIColor.red
        var numberLabel = UILabel(frame: CGRect(x: 4, y: 1, width: 15, height: 15))
        numberLabel.text=String(number)
        numberLabel.font.withSize(2)
        numberLabel.textColor=UIColor.white
        bageView.addSubview(numberLabel)
        let tabFrame = self.frame
        
        // 确定小红点的位置
        let percentX: CGFloat = (CGFloat(itemIndex) + 0.59) / tabbarItemNums
        let x: CGFloat = CGFloat(ceilf(Float(percentX * tabFrame.size.width)))
        let y: CGFloat = CGFloat(ceilf(Float(0.115 * tabFrame.size.height)))
        bageView.frame = CGRect(x: x, y: y, width: 17, height: 17)
        self.addSubview(bageView)
    }
    
    // MARK:- 隐藏小红点
    func hideBadg(on itemIndex: Int) {
        // 移除小红点
        self.removeBadgeOn(index: itemIndex)
    }
    
    // MARK:- 移除小红点
    fileprivate func removeBadgeOn(index itemIndex: Int) {
        // 按照tag值进行移除
        _ = subviews.map {
            if $0.tag == itemIndex + lxfFlag {
                $0.removeFromSuperview()
            }
        }
    }
}
