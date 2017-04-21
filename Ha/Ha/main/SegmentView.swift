//
//  SegmentView.swift
//  Ha
//
//  Created by zhy on 2017/4/21.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

import UIKit

class SegmentView: UIView {
    
    @IBOutlet weak var jokeBtn: UIButton!
    @IBOutlet weak var imageBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = mainColor
        self.layer.cornerRadius = 3
        self.clipsToBounds = true;
        
        let maskPath1 = UIBezierPath.init(roundedRect: self.jokeBtn.frame, byRoundingCorners: [.topLeft,.bottomLeft], cornerRadii: CGSize(width: 3, height: 3))
        let maskLayer1 = CAShapeLayer();
        maskLayer1.frame = self.jokeBtn.bounds;
        maskLayer1.path = maskPath1.cgPath;
        self.jokeBtn.layer.mask = maskLayer1;

        let maskPath2 = UIBezierPath.init(roundedRect: self.jokeBtn.frame, byRoundingCorners: [.topRight,.bottomRight], cornerRadii: CGSize(width: 3, height: 3))
        let maskLayer2 = CAShapeLayer();
        maskLayer2.frame = self.jokeBtn.bounds;
        maskLayer2.path = maskPath2.cgPath;
        self.imageBtn.layer.mask = maskLayer2;
    }
    
    @IBAction func switchAction(_ sender: Any) {
        
        let button = sender as! UIButton
        if button.tag == 100 {
        
            self.jokeBtn.isSelected = true
            self.imageBtn.isSelected = false
        }else {
        
            self.jokeBtn.isSelected = false
            self.imageBtn.isSelected = true
        }
        
    }
}
