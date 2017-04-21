//
//  NoDataView.swift
//  Ha
//
//  Created by zhy on 2017/4/21.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

import UIKit

class NoDataView: UIView {

    @IBOutlet weak var tipsImage: UIImageView!
    @IBOutlet weak var tipsLabel: UILabel!
    
    static func shareTipsView(frame : CGRect,tips : String) -> NoDataView{
        
        let view = Bundle.main.loadNibNamed("NoDataView", owner: self, options: nil)?.last as? NoDataView
        view?.frame = frame
        view?.tipsLabel.text = tips
        return view!
        
    }
}
