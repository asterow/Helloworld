//
//  AppDelegate.swift
//  Helloworld
//
//  Created by Astero on 20/03/2017.
//  Copyright © 2017 Astero. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        let notifSample = NotifSample()
        notifSample.sayHi()
        notifSample.requestPushPermission()
        notifSample.setCustomActions()
        
        // Configure the user interactions first.
        //self.configureUserInteractions()
        
        
        // Register with APNs
        UIApplication.shared.registerForRemoteNotifications()

        
        return true
    }
    
    // is called when : [app is in BG and notif's payload contains "content-available" : 1 ] or [app is in FG and notif is received]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(.newData)
        print("Notif received !!! :)")
    }
    
    
    
    // Handle remote notification registration.
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        // Forward the token to your provider, using a custom method.
        //self.enableRemoteNotificationFeatures()
        
        let deviceTokenString = deviceToken.reduce("") {$0 + String(format: "%02X", $1)}
        let pushToken = String(format: "%@", deviceToken as CVarArg)
        print("\nTOKEN1 = \(deviceTokenString)")
        print("\nTOKENBis = \(pushToken)")

        
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // The token is not currently available.
        print("Remote notification support is unavailable due to error: \(error.localizedDescription)")
        //self.disableRemoteNotificationFeatures()
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

