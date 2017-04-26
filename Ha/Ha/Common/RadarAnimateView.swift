//
//  RadarAnimateView.swift
//  Ha
//
//  Created by zhy on 2017/4/26.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

import UIKit

class RadarAnimateView: UIView {

    var rect : CGRect!
    var view1 : UIView!
    var time : CGFloat = 1.5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.rect = frame;
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = false
        let circle = UIView(frame: CGRect(x: frame.width/2-5, y: frame.height/2-5, width: 10, height: 10))
        circle.layer.cornerRadius = 5
        circle.backgroundColor = mainColor
        self.addSubview(circle)
        
        self.view1 = UIView(frame: CGRect(x: frame.width/2-15, y: frame.height/2-15, width: 30, height: 30))
        self.view1.layer.cornerRadius = 15
        self.view1.backgroundColor = UIColor.red
        self.addSubview(self.view1)

        
        self.view1.layer.add(self.animation(), forKey: "pulse")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
         let context = UIGraphicsGetCurrentContext()
         context?.setLineWidth(1)
         context?.setStrokeColor(mainColor.cgColor)
        let f : CGFloat = rect.size.width / 2
        
        for index in 0  ..< 2  {
            
            let w : CGFloat = rect.size.width-f * CGFloat(index)
            let h : CGFloat = rect.size.width - f * CGFloat(index)
            
            context?.addEllipse(in: CGRect(x: rect.width/2 - w/2, y: rect.height/2 - h/2, width: w, height: h))
            context?.strokePath()
        }
        
    }
    
    
    func animation() -> CAAnimationGroup {
        
        let mediaTiming = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        
        let scaleAnimate = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimate.fromValue = 0
        scaleAnimate.toValue = self.rect.width/30
        scaleAnimate.duration = CFTimeInterval(self.time)
        
        let opacityAnimate = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimate.duration = CFTimeInterval(self.time)
        opacityAnimate.values = [0.7,0.7,0]
        opacityAnimate.keyTimes = [0,0.2,1]
        opacityAnimate.isRemovedOnCompletion = false
        
        let groupAnimate = CAAnimationGroup()
        groupAnimate.duration = CFTimeInterval(self.time)
        groupAnimate.repeatCount = MAXFLOAT
        groupAnimate.isRemovedOnCompletion =  false
        groupAnimate.timingFunction = mediaTiming
        
        let array = [scaleAnimate,opacityAnimate]
        groupAnimate.animations = array
        
        return groupAnimate
    }
}
