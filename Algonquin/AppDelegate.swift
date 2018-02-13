//
//  AppDelegate.swift
//  Algonquin
//
//  Created by Peter Soboyejo on 8/23/17.
//  Copyright © 2017 Peter Soboyejo. All rights reserved.
//

import UIKit
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Twitter.sharedInstance().start(withConsumerKey:"KMV1e7k4bCRbQ1AxkngeBKwn9", consumerSecret:"cQH8idzu9mBHtCOgx1wPdmcYU7dNVfGP5FeC0cxj77tsM7eAv5")
        
        UINavigationBar.appearance().barTintColor = Colors.mainRed
        UINavigationBar.appearance().tintColor = UIColor.white
        
        let attributes: [String: AnyObject] = [
            NSForegroundColorAttributeName: UIColor.white
        ]
        
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().titleTextAttributes = attributes
        
        return true
    }

}

