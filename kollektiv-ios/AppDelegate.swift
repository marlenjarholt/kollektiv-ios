//
//  AppDelegate.swift
//  kollektiv-ios
//
//  Created by Simen Fonnes & Marlen Jarholt on 07/09/2019.
//  Copyright © 2019 Simen Fonnes & Marlen Jarholt. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isLoggedIn = false
    static var collective: Collective?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if isLoggedIn {
            launchFrontPageViewController()
        } else {
            launchOnboardingViewController()
        }
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        
        UINavigationBar.appearance().barTintColor = Colors.mainColor
        
        UITabBar.appearance().barTintColor = Colors.mainColor
        UITabBar.appearance().tintColor = .black
        
        return true
    }
    
    func launchFrontPageViewController(){
        let frontPageViewController = UINavigationController.init(rootViewController: FrontPageViewController.init())
        
        let shoppingListViewController = UINavigationController.init(rootViewController: ShoppingListViewController.init())
        
        let inFridgeViewController = UINavigationController.init(rootViewController: InFridgeViewController.init())
        
        let frontPageItem = UITabBarItem.init()
        frontPageItem.title = "Hjem"
        frontPageViewController.tabBarItem = frontPageItem
        
        let shoppingListItem = UITabBarItem.init()
        shoppingListItem.title = "Handleliste"
        shoppingListViewController.tabBarItem = shoppingListItem
        
        let inFridgeItem = UITabBarItem.init()
        inFridgeItem.title = "I kjøleskapet"
        inFridgeViewController.tabBarItem = inFridgeItem
        
        let tabViewController = UITabBarController.init()
        tabViewController.viewControllers = [
            frontPageViewController,
            shoppingListViewController,
            inFridgeViewController
        ]
        
        window?.rootViewController = tabViewController
    }
    
    func launchOnboardingViewController(){
        
        let onboardingViewController = UINavigationController.init(
            rootViewController: OnboardingViewController.init()) 
        window?.rootViewController = onboardingViewController
    }
    
    class func getCollective() -> Collective? {
        return collective
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

