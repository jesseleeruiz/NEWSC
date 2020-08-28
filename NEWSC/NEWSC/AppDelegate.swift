//
//  AppDelegate.swift
//  NEWSC
//
//  Created by Jesse Ruiz on 8/23/20.
//  Copyright © 2020 Jesse Ruiz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let categories = ["Business", "Culture", "Sport", "Tech", "Travel"]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 1. Grab the root view controller and safely typecast to be a tab bar controller
        if let tabBarController = window?.rootViewController as? UITabBarController {
            
            // 2. Create an empty view controller array ready to hold the view controllers for our app
            var viewControllers = [UIViewController]()
            
            // 3. Loop over all the categories
            for category in categories {
                
                // 4. Create a new view controller for this category
                if let newsController = tabBarController.storyboard?.instantiateViewController(withIdentifier: "News") as? NEWSCCollectionViewController {
                    
                    // 5. Give it the title of this category
                    newsController.title = category
                    
                    // 6. Append it to our array of view controllers
                    viewControllers.append(newsController)
                }
            }
            // 7. Assign the view controller array to the tab bar controller
            tabBarController.viewControllers = viewControllers
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }


}

