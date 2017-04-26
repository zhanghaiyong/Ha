//
//  AppDelegate.swift
//  Ha
//
//  Created by zhy on 2017/4/14.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mapManager : BMKMapManager?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        self.mapManager = BMKMapManager()
        if !(self.mapManager?.start("ErrYH572owYbsLK1TswTzHGLhml51EpN", generalDelegate: nil))! {
        
            print("manager start failed!")
        }

        
        if UserDefaults.standard.object(forKey: textPage) as? String == "500" ||  UserDefaults.standard.object(forKey: textPage) == nil{
             UserDefaults.standard.set("0", forKey: textPage)
             UserDefaults.standard.synchronize()
        }
        
        if UserDefaults.standard.object(forKey: imagePage) as? String == "500" || UserDefaults.standard.object(forKey: imagePage) == nil{
            UserDefaults.standard.set("0", forKey: imagePage)
            UserDefaults.standard.synchronize()
        }
        
        
        
        UINavigationBar.appearance().tintColor = UIColor.white;
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for: UIBarMetrics.default)
        
        UINavigationBar.appearance().barTintColor = mainColor

        
        let tabbar = UITabBarController()

        let mainNv = UINavigationController(rootViewController: MainViewController())
        let nearByNv = UINavigationController(rootViewController: NearByController())
        
        let tabBatItem1 = UITabBarItem(title: "开心一刻", image: nil, selectedImage: nil)
        mainNv.tabBarItem = tabBatItem1
        
        let tabBatItem2 = UITabBarItem(title: "附近看看", image: nil, selectedImage: nil)
        nearByNv.tabBarItem = tabBatItem2
        
        tabbar.viewControllers = [mainNv,nearByNv]
        
        self.window?.rootViewController = tabbar
        
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

