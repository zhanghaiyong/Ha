//
//  SegmentView.swift
//  Ha
//
//  Created by zhy on 2017/4/21.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

typealias segmentBlock = (_ tag : Int) ->Void

import UIKit

class SegmentView: UIView {
    
    @IBOutlet weak var jokeBtn: UIButton!
    @IBOutlet weak var imageBtn: UIButton!
    var callBack : segmentBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.jokeBtn.backgroundColor = mainColor
        self.backgroundColor = mainColor
        self.layer.cornerRadius = 3
        self.layer.borderColor = mainColor.cgColor
        self.layer.borderWidth = 1
        self.clipsToBounds = true;
        
        let maskPath1 = UIBezierPath.init(roundedRect: self.jokeBtn.bounds, byRoundingCorners: [.topLeft,.bottomLeft], cornerRadii: CGSize(width: 3, height: 3))
        let maskLayer1 = CAShapeLayer();
        maskLayer1.frame = self.jokeBtn.bounds;
        maskLayer1.path = maskPath1.cgPath;
        self.jokeBtn.layer.mask = maskLayer1;

        let maskPath2 = UIBezierPath.init(roundedRect: self.jokeBtn.bounds, byRoundingCorners: [.topRight,.bottomRight], cornerRadii: CGSize(width: 3, height: 3))
        let maskLayer2 = CAShapeLayer();
        maskLayer2.frame = self.jokeBtn.bounds;
        maskLayer2.path = maskPath2.cgPath;
        self.imageBtn.layer.mask = maskLayer2;
        
        
    }
    
    @IBAction func switchAction(_ sender: Any) {
        
        let button = sender as! UIButton
        
        switch button.tag {
        case 100:
            self.jokeBtn.backgroundColor    = mainColor
            self.imageBtn.backgroundColor   = UIColor.white
            
            self.jokeBtn.isSelected    = true
            self.imageBtn.isSelected   = false
            
        break
        case 200:
            self.imageBtn.backgroundColor   = mainColor
            self.jokeBtn.backgroundColor    = UIColor.white
            
            self.jokeBtn.isSelected    = false
            self.imageBtn.isSelected   = true
            
        break
            
        default:
            break
        }

        self.callBack!(button.tag)
    }
}
