//
//  NearByController.swift
//  Ha
//
//  Created by zhy on 2017/4/26.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

import UIKit

class NearByController: UIViewController,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKRadarManagerDelegate {

    var mapView : BMKMapView?
    var locService : BMKLocationService!
    var radarManager : BMKRadarManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = {[
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: kFONT, size: 24.0)!
            ]}()
        self.title = "附近看看"
        
        self.mapView = BMKMapView(frame: self.view.bounds)
        self.view = self.mapView
        self.mapView?.userTrackingMode = BMKUserTrackingModeHeading
        self.mapView?.showsUserLocation = true//显示定位图层
        
        let radar = RadarAnimateView(frame: self.view.bounds)
        self.view.addSubview(radar)
        
        //定位
        self.locService = BMKLocationService()
        self.locService.delegate = self
        
    }
    
    
    //BMKLocationServiceDelegate
    //处理方向变更信息
    func didUpdateUserHeading(_ userLocation: BMKUserLocation!) {
        
        print(userLocation.heading)
    }
    
    //处理位置坐标更新
    func didUpdate(_ userLocation: BMKUserLocation!) {
        
        self.mapView?.updateLocationData(userLocation)
        
        let center = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
        let span = BMKCoordinateSpanMake(0.038325, 0.028045);
        self.mapView?.limitMapRegion = BMKCoordinateRegionMake(center, span);////限制地图显示范围
        self.mapView?.isRotateEnabled = false;//禁用旋转手势
        
        //定位成功后，开始上传位置
        //周边搜索Manager
        self.radarManager = BMKRadarManager.getInstance()
        //设置userid
//        self.radarManager.userId = AVUser.current()?.email
        self.radarManager.add(self as BMKRadarManagerDelegate)
        
        //上传位置信息
        let myInfo = BMKRadarUploadInfo()
        myInfo.extInfo = AVUser.current()?.email
        myInfo.pt = center
        
        if self.radarManager.uploadInfoRequest(myInfo) {
        
            print("上传位置信息 成功")
            
            let options = BMKRadarNearbySearchOption.init()
            options.radius = 8000//检索半径
            options.sortType = BMK_RADAR_SORT_TYPE_DISTANCE_FROM_NEAR_TO_FAR//排序方式
            options.centerPt = center
            if self.radarManager.getRadarNearbySearchRequest(options) {
            
                print("检索成功")
            }else {
                print("检索失败")
            }
            
        }else {
            print("上传位置信息 失败")
        }
        
        self.locService.stopUserLocationService()
    }
    
    //BMKRadarManagerDelegate
    func onGetRadarNearbySearch(_ result: BMKRadarNearbyResult!, error: BMKRadarErrorCode) {
        
        print("检索的周边信息 \(result)")
        if (error == BMK_RADAR_NO_ERROR) { //成功
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mapView?.delegate = self;
        //启动LocationService
        self.locService.startUserLocationService()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        BMKRadarManager.releaseInstance()
        self.radarManager.remove(self)
        self.mapView?.delegate = nil
    }
}
