
import Foundation
import UIKit

let kSCREENWIDTH  = UIScreen.main.bounds.size.width

let kSCREENHEIGHT = UIScreen.main.bounds.size.height

let kFONT = "Bauhaus ITC"

let JHAppKey = "d19f1f3e2b3d80cd9ca26ece29a95e53"

let mainColor = UIColor.init(colorLiteralRed: 100/255, green: 149/255, blue: 237/255, alpha: 1)

//按更新时间查询笑话
let jokeForTime = "http://japi.juhe.cn/joke/content/list.from"

//最新笑话
let newJoke = "http://japi.juhe.cn/joke/content/text.from"

//按更新时间查询趣图
let imageForTime = "http://japi.juhe.cn/joke/img/list.from"

//最新趣图
let newImage = "http://japi.juhe.cn/joke/img/text.from"
