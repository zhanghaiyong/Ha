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
    var dataSource = NSMutableArray()
    var noticeLabel : UILabel?
    var noDataView : NoDataView?
    var segment : SegmentView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSubViews()
        self.tableView?.mj_header.beginRefreshing()
        
        self.segment = Bundle.main.loadNibNamed("SegmentView", owner: self, options: nil)?.last as? SegmentView
        self.segment?.frame = CGRect(x: kSCREENWIDTH/2-60, y: (self.tableView?.bottom)!-50, width: 120, height: 40)
        self.view.addSubview(self.segment!)
        
    }

    func initSubViews() {
        
        self.noticeLabel = UILabel(frame: CGRect(x: -kSCREENWIDTH, y: 64, width: kSCREENWIDTH, height: 40))
        self.noticeLabel?.font = UIFont(name: kFONT, size: 16)
        self.noticeLabel?.clipsToBounds = true
        self.noticeLabel?.textColor = UIColor.white
        self.noticeLabel?.textAlignment = .center
        self.noticeLabel?.backgroundColor = UIColor(white: 0, alpha: 0.7)
        UIApplication.shared.keyWindow?.addSubview(self.noticeLabel!)
        
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
        
        let params = ["sort":"desc",
                      "page":"1",
                      "pagesize":"10",
                      "key":JHAppKey,
                      "time":(String(NSDate().timeIntervalSince1970) as NSString).substring(to: 10)
        ]
        
        let manager = AFHTTPSessionManager()
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "text/html") as? Set<String>
        manager.get(jokeForTime, parameters: params, progress: { (Progress) in
            
            
        }, success: { (task, responseObject) in
            
            self.tableView?.mj_header.endRefreshing()
            print(responseObject as AnyObject)
            
            if String(describing: (responseObject as! NSDictionary)["error_code"]) == "0" {
            
                let result = (responseObject as! NSDictionary)["result"]
                let data = (result as! NSDictionary)["data"]
                
                if (data != nil) {
                    
                    for model in data as! NSArray {
                        
                        self.dataSource.insert(JokeModel.mj_object(withKeyValues: model), at: self.dataSource.count)
                    }
                    
                    
                    UIView.animate(withDuration: 0.5, animations: {
                        
                        self.noticeLabel?.text = "更新了\((data as! NSArray).count)条数据"
                        self.noticeLabel?.frame = CGRect(x: 0, y: 64, width: kSCREENWIDTH, height: 40)
                    }, completion: { (finished) in
                        
                        UIView.animate(withDuration: 0, delay: 1.5, options: .curveEaseInOut, animations: {
                            
                            self.noticeLabel?.frame = CGRect(x: kSCREENWIDTH, y: 64, width: kSCREENWIDTH, height: 40)
                            
                        }, completion: { (finished) in
                            self.noticeLabel?.frame = CGRect(x: -kSCREENWIDTH, y: 64, width: kSCREENWIDTH, height: 40)
                        })
                        
                    })
                    
                    self.tableView?.reloadData()
                }
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
        
        
        if self.dataSource.count > 0 {
            
            let model = self.dataSource.lastObject as? JokeModel
            
            let params = ["sort":"desc",
                          "page":"1",
                          "pagesize":"10",
                          "key":JHAppKey,
                          "time":model?.unixtime
            ]
            let manager = AFHTTPSessionManager()
            manager.responseSerializer.acceptableContentTypes = NSSet(objects: "text/html") as? Set<String>
            manager.get(jokeForTime, parameters: params, progress: { (Progress) in
                
                
            }, success: { (task, responseObject) in
                
                self.tableView?.mj_footer.endRefreshing()
                
                let result = (responseObject as! NSDictionary)["result"]
                let data = (result as! NSDictionary)["data"]
                
                print(data ?? NSArray())
                
                if (data != nil) {
                    
                    for model in data as! NSArray {
                        
                        self.dataSource.add(JokeModel.mj_object(withKeyValues: model))
                        
                    }
                    self.tableView?.reloadData()
                }
                
            }) { (task, error) in
                
                print(error)
                self.tableView?.mj_footer.endRefreshing()
            }
            
        }
    }
    
    
    //UITableViewDelegate && UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if self.dataSource.count == 0 {
            
            if self.noDataView == nil {
                
               self.noDataView = NoDataView.shareTipsView(frame: CGRect(x: (self.tableView?.width)!/2-50, y: (self.tableView?.height)!/2-65, width: 100, height: 130), tips: "暂无数据")
                self.tableView?.addSubview(self.noDataView!)
            }
        }else {
        
            if (self.noDataView != nil) {
             
                self.noDataView?.removeFromSuperview()
            }
        }
        
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("MainCell", owner: self, options: nil)?.last as? MainCell
        
        let jokeM = self.dataSource[indexPath.row] as? JokeModel
        cell?.contentLabel.text = jokeM?.content.replacingOccurrences(of: "&nbsp", with: "")
        
        return cell!
    }
    
}
