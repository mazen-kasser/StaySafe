//
//  AppDelegate.swift
//  StaySafe
//
//  Created by Mazen on 6/04/20.
//  Copyright © 2020 iProgram. All rights reserved.
//

import UIKit
import CloudKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // let AppDelegate handle push notification
        UNUserNotificationCenter.current().delegate = self
        
        // Ask user permission for sending push notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { authorized, error in
            if authorized {
                DispatchQueue.main.async(execute: {
                    application.registerForRemoteNotifications()
                })
            }
        })
        
        // When the app launch after user tap on notification (originally was not running / not in background)
        if(launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] != nil){
            
        }
        
        return true
    }
    
    // When user allowed push notification and the app has gotten the device token
    // (device token is a unique ID that Apple server use to determine which device to send push notification to)
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        // Create a subscription to the 'Notifications' Record Type in CloudKit
        // User will receive a push notification when a new record is created in CloudKit
        // Read more on https://developer.apple.com/library/archive/documentation/DataManagement/Conceptual/CloudKitQuickStart/SubscribingtoRecordChanges/SubscribingtoRecordChanges.html
        
        //         The predicate lets you define condition of the subscription, eg: only be notified of change if the newly created notification start with "A"
        // the TRUEPREDICATE means any new Notifications record created will be notified
        let subscription = CKQuerySubscription(recordType: "Notifications", predicate: NSPredicate(format: "TRUEPREDICATE"), options: .firesOnRecordCreation)
        
        // Here we customize the notification message
        let info = CKSubscription.NotificationInfo()
        
        // this will use the 'title' field in the Record type 'notifications' as the title of the push notification
        info.titleLocalizationKey = "%1$@"
        info.titleLocalizationArgs = ["title"]
        
        // if you want to use multiple field combined for the title of push notification
         info.subtitleLocalizationKey = "%1$@" // if want to add more, the format will be "%3$@" and so on
         info.subtitleLocalizationArgs = ["subtitle"]
        
        // this will use the 'content' field in the Record type 'notifications' as the content of the push notification
        info.alertLocalizationKey = "%1$@"
        info.alertLocalizationArgs = ["content"]
        
        // increment the red number count on the top right corner of app icon
        info.shouldBadge = true
        
        // use system default notification sound
        info.soundName = "default"
        
        subscription.notificationInfo = info
        
        // Save the subscription to Public Database in Cloudkit
        CKContainer.default().publicCloudDatabase.save(subscription, completionHandler: { subscription, error in
            if error == nil {
                // Subscription saved successfully
            } else {
                // Error occurred
            }
        })
        
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let application = UIApplication.shared
        
        if(application.applicationState == .active){
            print("app received notification while in foreground")
        }
        
        // show the notification alert (banner), and with sound
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let application = UIApplication.shared
        
        if(application.applicationState == .active){
            print("user tapped the notification bar when the app is in foreground")
        }
        
        if(application.applicationState == .inactive)
        {
            print("user tapped the notification bar when the app is in background")
        }
        
        // tell the app that we have finished processing the user’s action / response
        completionHandler()
    }
}
