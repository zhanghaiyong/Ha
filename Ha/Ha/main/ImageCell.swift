//
//  ImageCell.swift
//  Ha
//
//  Created by zhy on 2017/4/22.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {

    @IBOutlet weak var smallImage: UIImageView!

    @IBOutlet weak var Indicator: UIActivityIndicatorView!
    @IBOutlet weak var content: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
