//
//  BaseParams.swift
//  Ha
//
//  Created by zhy on 2017/4/25.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

import UIKit

class BaseParams: NSObject {

    //应用id
    var showapi_appid : String = "36545"
    //数字签名。
    var showapi_sign : String = "369395495b414f64b3b6cf4f96a0869a"
    //客户端时间。
    var showapi_timestamp : String = ""
    //签名生成方式
    var showapi_sign_method : String = "md5"
    //否用gzip方式压缩
    var showapi_res_gzip : String = "0"
    
}
