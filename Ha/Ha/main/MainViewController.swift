//
//  MainViewController.swift
//  Ha
//
//  Created by zhy on 2017/4/20.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var tableView : UITableView?
    var jokeDataSource = NSMutableArray()
    var imageDataSource = NSMutableArray()
    var noticeLabel : UILabel?
    var noDataView  : NoDataView?
    var segment : SegmentView?
    var typeTag : Int? = 100
    var jokePage : Int? = 0
    var ImagePage : Int? = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        if AVUser.current() == nil {
            
            let loginVC = LoginViewController()
            self.present(loginVC, animated: true, completion: nil)
        }else {
        
            self.initSubViews()
            self.tableView?.mj_header.beginRefreshing()
            
            self.segment = Bundle.main.loadNibNamed("SegmentView", owner: self, options: nil)?.last as? SegmentView
            self.segment?.frame = CGRect(x: kSCREENWIDTH/2-60, y: (self.tableView?.bottom)!-50, width: 120, height: 40)
            self.segment?.callBack = ({(tag) -> Void in
                
                self.typeTag = tag
                self.tableView?.mj_header.beginRefreshing()
            })
            self.view.addSubview(self.segment!)
            
            
            self.noticeLabel?.font = UIFont(name: kFONT, size: 16)
            self.noticeLabel?.clipsToBounds = true
            self.noticeLabel?.textColor = UIColor.white
            self.noticeLabel?.textAlignment = .center
            self.noticeLabel?.backgroundColor = UIColor(white: 0, alpha: 0.7)
            self.view.addSubview(self.noticeLabel!)
        }
    }

    func initSubViews() {
        
        self.noticeLabel = UILabel(frame: CGRect(x: -kSCREENWIDTH, y: 64, width: kSCREENWIDTH, height: 40))

        
        self.view.backgroundColor = UIColor.white
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: kSCREENHEIGHT))
        self.tableView?.delegate = self;
        self.tableView?.dataSource = self;
        self.tableView?.estimatedRowHeight = 300
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        self.tableView?.tableFooterView = UIView()
        self.tableView?.separatorInset = UIEdgeInsetsMake(0, -60, 0, -60)
        self.view.addSubview(self.tableView!)
        
        self.tableView?.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(MainViewController.headRefresh))
        self.tableView?.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(MainViewController.footRefresh))
    }
    
    func headRefresh() {
        
        ProgressHUD.show("")
        
        var page : Int?
        var url : String?
        if self.typeTag == 100 {
            
            self.jokePage! += 1
            page = self.jokePage
            url = newJoke
        }else {
        
            self.ImagePage! += 1
            url = newImage
            page = self.ImagePage
        }
        
        let params = ["page":page!,
                      "pagesize":10,
                      "key":JHAppKey,
        ] as [String : Any]
        
        let manager = AFHTTPSessionManager()
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "text/html") as? Set<String>
        manager.get(url!, parameters: params, progress: { (Progress) in
            
        }, success: { (task, responseObject) in
            
            ProgressHUD.showSuccess("加载完毕")
            
            self.tableView?.mj_header.endRefreshing()
            print(responseObject as AnyObject)
            
            if (responseObject as! NSDictionary)["error_code"] as! Int == 0 {
            
                let result = (responseObject as! NSDictionary)["result"]
                let data = (result as! NSDictionary)["data"]
                
                var tips : String = ""
                
                if (data != nil) {
                    
                    for model in data as! NSArray {
                        
                        if self.typeTag == 100 {
                            self.jokeDataSource.insert(JokeModel.mj_object(withKeyValues: model), at: 0)
                        }else {
                            self.imageDataSource.insert(JokeModel.mj_object(withKeyValues: model), at: 0)
                        }
                    }
                    
                    tips = "更新了\((data as! NSArray).count)条数据"
                    self.tableView?.reloadData()
                    
                }else {
                
                    tips = "没有最新的了！"
                }
                
                UIView.animate(withDuration: 0.5, animations: {
                    
                    self.noticeLabel?.text = tips
                    self.noticeLabel?.frame = CGRect(x: 0, y: 64, width: kSCREENWIDTH, height: 40)
                }, completion: { (finished) in
                    
                    UIView.animate(withDuration: 0, delay: 1.5, options: .curveEaseInOut, animations: {
                        
                        self.noticeLabel?.frame = CGRect(x: kSCREENWIDTH, y: 64, width: kSCREENWIDTH, height: 40)
                        
                    }, completion: { (finished) in
                        self.noticeLabel?.frame = CGRect(x: -kSCREENWIDTH, y: 64, width: kSCREENWIDTH, height: 40)
                    })
                })
            }else {
            
                ProgressHUD.showError("请求失败")
            }
            
        }) { (task, error) in
            
            ProgressHUD.showError("请求失败")
            print(error)
            self.tableView?.mj_header.endRefreshing()
        }
    }
    
    func footRefresh() {
        
        ProgressHUD.show("")
        var url : String?
        var time : String?
        if self.typeTag == 100 {
        
            url = jokeForTime
            if self.jokeDataSource.count > 0 {
                let model = self.jokeDataSource.lastObject as? JokeModel
                time = model?.unixtime
                
            }else {
                return
            }
        }else {
        
            url = imageForTime
            if self.imageDataSource.count > 0 {
                let model = self.imageDataSource.lastObject as? JokeModel
                time = model?.unixtime
                
            }else {
                return
            }
        }
        
        let params = ["sort":"desc",
                      "page":"1",
                      "pagesize":"10",
                      "key":JHAppKey,
                      "time":time
        ]
        let manager = AFHTTPSessionManager()
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "text/html") as? Set<String>
        manager.get(url!, parameters: params, progress: { (Progress) in
            
        }, success: { (task, responseObject) in
            
            ProgressHUD.showSuccess("加载完毕")
            
            if (responseObject as! NSDictionary)["error_code"] as! Int == 0 {
                
                self.tableView?.mj_footer.endRefreshing()
                
                let result = (responseObject as! NSDictionary)["result"]
                let data = (result as! NSDictionary)["data"]
                
                print(data ?? NSArray())
                
                if (data != nil) {
                    
                    for model in data as! NSArray {
                        
                        if self.typeTag == 100 {
                            self.jokeDataSource.add(JokeModel.mj_object(withKeyValues: model))
                        }else {
                        
                            self.imageDataSource.add(JokeModel.mj_object(withKeyValues: model))
                        }
                    }
                    self.tableView?.reloadData()
                }
            }
            
        }) { (task, error) in
            
            print(error)
            self.tableView?.mj_footer.endRefreshing()
        }
    }
    
    //UITableViewDelegate && UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.typeTag == 100 {
            
            if self.jokeDataSource.count == 0 {
                
                if self.noDataView == nil {
                    
                    self.noDataView = NoDataView.shareTipsView(frame: CGRect(x: (self.tableView?.width)!/2-50, y: (self.tableView?.height)!/2-65, width: 100, height: 130), tips: "暂无数据")
                    self.tableView?.addSubview(self.noDataView!)
                }
            }else {
                
                if (self.noDataView != nil) {
                    
                    self.noDataView?.removeFromSuperview()
                }
            }
            
            return self.jokeDataSource.count
            
        }
        
        if self.imageDataSource.count == 0 {
            
            if self.noDataView == nil {
                
                self.noDataView = NoDataView.shareTipsView(frame: CGRect(x: (self.tableView?.width)!/2-50, y: (self.tableView?.height)!/2-65, width: 100, height: 130), tips: "暂无数据")
                self.tableView?.addSubview(self.noDataView!)
            }
        }else {
            
            if (self.noDataView != nil) {
                
                self.noDataView?.removeFromSuperview()
            }
        }
        
        return self.imageDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if self.typeTag == 100 {
        
            let cell = Bundle.main.loadNibNamed("MainCell", owner: self, options: nil)?.last as? MainCell
            
            let jokeM = self.jokeDataSource[indexPath.row] as? JokeModel
            cell?.contentLabel.text = jokeM?.content.replacingOccurrences(of: "&nbsp", with: "")
            
            return cell!
        }
        
        let cell = Bundle.main.loadNibNamed("ImageCell", owner: self, options: nil)?.last as? ImageCell
        
        let imageM = self.imageDataSource[indexPath.row] as? JokeModel
        cell?.content.text = imageM?.content.replacingOccurrences(of: "&nbsp", with: "")
        
        let Indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        Indicator.center = (cell?.smallImage.center)!
        cell?.contentView.addSubview(Indicator)
        cell?.smallImage.sd_setImage(with: URL.init(string: (imageM?.url)!), placeholderImage: UIImage(named: "noImage"), options: .retryFailed, progress: { (a, b) in
            
        }, completed: { (image, error, cacheType, url) in
            
            Indicator.removeFromSuperview()
        })
        return cell!
   
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    
        if (!(self.segment?.isHidden)!) {
            
            self.segment?.isHidden = true
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if (self.segment?.isHidden)! {
            self.segment?.isHidden = false
        }
    }
    
}
