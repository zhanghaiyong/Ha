//
//  jokeParams.swift
//  Ha
//
//  Created by zhy on 2017/4/25.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

import UIKit

class jokeParams: BaseParams {

    //从这个时间以来最新的笑话. 格式：yyyy-MM-dd
    var time : String? = ""
    //第几页。
    var page : String? = "0"
    //每页最大记录数。其值为1至50。
    var maxResult : String? = "20"
}
