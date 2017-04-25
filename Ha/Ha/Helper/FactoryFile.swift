//
//  FactoryFile.swift
//  Ha
//
//  Created by zhy on 2017/4/19.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//



import UIKit

class GeneralFactory: NSObject {

   static func transferStringToColor(_ colorStr:String) -> UIColor {
        
        var color = UIColor.red
        var cStr : String = colorStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if cStr.hasPrefix("#") {
            let index = cStr.index(after: cStr.startIndex)
            cStr = cStr.substring(from: index)
        }
        if cStr.characters.count != 6 {
            return UIColor.black
        }
        
        let rRange = cStr.startIndex ..< cStr.index(cStr.startIndex, offsetBy: 2)
        let rStr = cStr.substring(with: rRange)
        
        let gRange = cStr.index(cStr.startIndex, offsetBy: 2) ..< cStr.index(cStr.startIndex, offsetBy: 4)
        let gStr = cStr.substring(with: gRange)
        
        let bIndex = cStr.index(cStr.endIndex, offsetBy: -2)
        let bStr = cStr.substring(from: bIndex)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rStr).scanHexInt32(&r)
        Scanner(string: gStr).scanHexInt32(&g)
        Scanner(string: bStr).scanHexInt32(&b)
        
        color = UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
        
        return color
    }

}
