//
//  AppDelegate.swift
//  todoey
//
//  Created by Deepak Balaji on 1/20/19.
//  Copyright © 2019 Deepak Balaji. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        
        //App's starting point
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
       
        
        // data storage in the app to keep the data active
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       
        
        // App goes into backgroud
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
       // App comes into foreground
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
       // App terminated  by user or by system
    }


}

