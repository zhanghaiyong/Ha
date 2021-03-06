//
//  MainViewController.swift
//  Ha
//
//  Created by zhy on 2017/4/20.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {

    //文本
    var textTable : UITableView?
    //图片
    var imageTable : UITableView?
    
    var textData = NSMutableArray()
    var imageData = NSMutableArray()
    var scrolView : UIScrollView?
    var textFootParams : jokeParams = jokeParams()
    var imageFootParams : jokeParams = jokeParams()
    
    var segment : SegmentView?
    
    var noDataView  : NoDataView?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = {[
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: kFONT, size: 24.0)!
            ]}()
        self.title = "开心一刻"
        
        if AVUser.current() != nil {
            
            let loginVC = LoginViewController()
            self.present(loginVC, animated: true, completion: nil)
        }else {
        
            self.initSubViews()
            
            self.segment = Bundle.main.loadNibNamed("SegmentView", owner: self, options: nil)?.last as? SegmentView
            self.segment?.frame = CGRect(x: kSCREENWIDTH/2-50, y: (self.scrolView?.bottom)!-50, width: 100, height: 38)
            self.segment?.callBack = ({(tag) -> Void in
                
                switch tag {
                case 100:
                    self.scrolView?.contentOffset = CGPoint(x: 0, y: (self.scrolView?.contentOffset.y)!)
                    if self.textData.count == 0 {
                        
                        self.textFootRefresh()
                    }
                    break
                case 200:
                    self.scrolView?.contentOffset = CGPoint(x: kSCREENWIDTH, y: (self.scrolView?.contentOffset.y)!)
                    if self.imageData.count == 0 {
                        
                        self.imageFootRefresh()
                    }
                    break
                default:
                    break
                }
                
            })
            self.view.addSubview(self.segment!)
        }
    }
    

    func initSubViews() {
        
        self.scrolView = UIScrollView(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: kSCREENHEIGHT-49))
        self.scrolView?.contentSize = CGSize(width: 2*kSCREENWIDTH, height: kSCREENHEIGHT-49)
        self.scrolView?.isPagingEnabled = true
        self.scrolView?.delegate = self
        self.scrolView?.isScrollEnabled = false
        self.scrolView?.bounces = false
        self.view.addSubview(self.scrolView!)
        

        self.textTable = UITableView(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: kSCREENHEIGHT-49))
        self.textTable?.delegate = self;
        self.textTable?.dataSource = self;
        self.textTable?.estimatedRowHeight = 300
        self.textTable?.rowHeight = UITableViewAutomaticDimension
        self.textTable?.tableFooterView = UIView()
        self.scrolView!.addSubview(self.textTable!)
        self.textTable?.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(MainViewController.textFootRefresh))
        self.textFootRefresh()
        
        self.imageTable = UITableView(frame: CGRect(x: kSCREENWIDTH, y: 0, width: kSCREENWIDTH, height: kSCREENHEIGHT-49))
        self.imageTable?.delegate = self;
        self.imageTable?.dataSource = self;
        self.imageTable?.register(ImageCell.classForCoder(), forCellReuseIdentifier: "imageCell")
        self.imageTable?.estimatedRowHeight = 100
        self.imageTable?.rowHeight = UITableViewAutomaticDimension
        self.imageTable?.tableFooterView = UIView()
        self.imageTable?.separatorInset = UIEdgeInsetsMake(0, -60, 0, -60)
        self.scrolView!.addSubview(self.imageTable!)
        self.imageTable?.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(MainViewController.imageFootRefresh))
        
    }
    
    
    func imageFootRefresh() {
     
        ProgressHUD.show("")
        
        self.imageFootParams.time = "2000-01-10"
        let tp : String = UserDefaults.standard.object(forKey: imagePage) as! String
        self.imageFootParams.page = "\(Int(tp)! + 1)"
        UserDefaults.standard.set(self.imageFootParams.page, forKey: imagePage)
        UserDefaults.standard.synchronize()
        
        let manager = AFHTTPSessionManager()
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json") as? Set<String>
        manager.get(imageUrl, parameters: self.imageFootParams.mj_keyValues(), progress: { (Progress) in
            
        }, success: { (task, responseObject) in
            
            ProgressHUD.showSuccess("加载完毕")
            
            self.imageTable?.mj_footer.endRefreshing()
            print(responseObject as AnyObject)
            
            if (responseObject as! NSDictionary)["showapi_res_code"] as! Int == 0 {
                
                let result = (responseObject as! NSDictionary)["showapi_res_body"]
                let data = (result as! NSDictionary)["contentlist"]
                
                if (data != nil) {
                    
                    let array = JokeModel.mj_objectArray(withKeyValuesArray: data)
                    self.imageData.addObjects(from: array as! [Any])
                    self.imageTable?.reloadData()
                }
            }else {
                
                ProgressHUD.showError("请求失败")
            }
            
        }) { (task, error) in
            
            ProgressHUD.showError("请求失败")
            print(error)
            self.imageTable?.mj_footer.endRefreshing()
        }
    }
    
    func textFootRefresh() {
        
        ProgressHUD.show("")

        self.textFootParams.time = "2000-01-10"
        let tp : String = UserDefaults.standard.object(forKey: textPage) as! String
        self.textFootParams.page = "\(Int(tp)! + 1)"
        UserDefaults.standard.set(self.textFootParams.page, forKey: textPage)
        UserDefaults.standard.synchronize()
        
        let manager = AFHTTPSessionManager()
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json") as? Set<String>
        manager.get(textUrl, parameters: self.textFootParams.mj_keyValues(), progress: { (Progress) in
            
        }, success: { (task, responseObject) in
            
            ProgressHUD.showSuccess("加载完毕")
            
            self.textTable?.mj_footer.endRefreshing()
            print(responseObject as AnyObject)
            
            if (responseObject as! NSDictionary)["showapi_res_code"] as! Int == 0 {
                
                let result = (responseObject as! NSDictionary)["showapi_res_body"]
                let data = (result as! NSDictionary)["contentlist"]

                if (data != nil) {
                    
                    let array = JokeModel.mj_objectArray(withKeyValuesArray: data)
                    self.textData.addObjects(from: array as! [Any])
                    self.textTable?.reloadData()
                }
            }else {
                
                ProgressHUD.showError("请求失败")
            }
            
        }) { (task, error) in
            
            ProgressHUD.showError("请求失败")
            print(error)
            self.textTable?.mj_footer.endRefreshing()
        }
    }
    
    //UITableViewDelegate && UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == textTable {
            return self.textData.count
        }else {
        
            return self.imageData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView == textTable {
            let cell = Bundle.main.loadNibNamed("MainCell", owner: self, options: nil)?.last as? MainCell
            
            let model = self.textData[indexPath.row] as? JokeModel
            cell?.contentLabel.text = model?.text.replacingOccurrences(of: "<p></p>", with: "").replacingOccurrences(of: "<br />", with: "")
            cell?.titleLabel.text = model?.title
            
            return cell!
        }else {
        
            let cell = Bundle.main.loadNibNamed("ImageCell", owner: self, options: nil)?.last as? ImageCell
            
            let model = self.imageData[indexPath.row] as? JokeModel
            cell?.content.text = model?.title
            cell?.smallImage.image = UIImage(named: "noImage")
   
            let imageV = UIImageView(frame: CGRect(x: 0, y: (cell?.content.bottom)!, width: kSCREENWIDTH, height: 100))
            imageV.sd_setImage(with: URL.init(string: (model?.img)!), placeholderImage: UIImage(named: "noImage"), options: .retryFailed, progress: { (a, b) in
                
            }, completed: { (image, error, type, url) in
                
                cell?.smallImage.image = image
                cell?.Indicator.stopAnimating()
                cell?.Indicator.isHidden = true
            })
            
            return cell!
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let offSet = scrollView.contentOffset.y;
        let alpha = (offSet - 64)/64;
        
        
        if Float((self.segment?.alpha)!) > 0.0 {
            self.segment?.alpha = 1 - alpha
        }
    }
 
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        self.segment?.alpha = 1
    }
    
}
